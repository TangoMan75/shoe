# 📱 Android Recipes

Helpers to unlock, root, back up and unbrick Android devices. The root sequence is written around the **OnePlus Nord (AC2003 / `avicii`)**, but most commands work on any A/B device with an unlocked bootloader.

The main entry point is `root_oneplus_nord`, which boots PitchBlack Recovery (PBRP) from RAM with `fastboot boot`, backs up both boot slots, flashes Magisk and reboots. Recovery itself is never replaced.

## 🔐 `boot_a` and `boot_b` backups

`_backup_boot_partitions` dumps the **boot partitions of both slots** to `${backup_dir}` (`./oneplus_nord/backup` by default):

```
boot_a.img
boot_b.img
```

### What these files are

They are **boot images**, not recovery images. The `_a` / `_b` suffix is only the slot name on an A/B ("seamless update") device.

A boot image is a container (magic `ANDROID!`) holding:

| Component                       | Purpose                                                              |
| ------------------------------- | -------------------------------------------------------------------- |
| **Kernel**                      | The Linux kernel (`Image` / `zImage`)                                |
| **Generic ramdisk**             | `init`, `init.rc`, first-stage mount logic                           |
| **DTB / DTO**                   | Device tree blobs (Android 11+ usually moves these to `vendor_boot`) |
| **cmdline, header, AVB footer** | Boot arguments, signature and hash information                       |

These are the **stock, unpatched** images, saved before Magisk modifies the active slot. They are the files you flash back to remove root or to recover from a bad boot patch.

### Why they are not "the recovery image"

Older non-A/B devices (Android ≤ 9) had a dedicated `recovery` partition. A/B devices dropped it: recovery mode lives in the **boot ramdisk** ("recovery-as-ramdisk"). The bootloader sets a bootloader control block (BCB) message and the boot image's ramdisk starts `init` in recovery mode instead of normal boot.

So on the OnePlus Nord:

- `boot_a` / `boot_b` are the **normal boot images**.
- They *do* contain the recovery ramdisk, which is why the name is misleading.
- There is **no separate `recovery` partition** to back up.
- PBRP is booted from RAM (`fastboot boot`) and writes nothing to storage.

### Partitions you may also meet

| Partition     | Introduced     | Contents                                                                    |
| ------------- | -------------- | --------------------------------------------------------------------------- |
| `boot`        | always         | kernel, plus ramdisk on older and A/B layouts                               |
| `init_boot`   | Android 13+    | generic ramdisk moved out of `boot` — what Magisk patches on modern devices |
| `vendor_boot` | Android 11+    | vendor ramdisk and DTB / DTBO                                               |
| `recovery`    | non-A/B, older | standalone recovery image, absent on most A/B phones                        |

On Android 13+ devices, restoring `boot` alone often does **not** remove root: check whether `init_boot` was patched instead. The Nord predates `init_boot`, so `boot` is the correct partition here.

### How the backup runs

1. Locate the block device directory: `/dev/block/by-name`, falling back to `/dev/block/bootdevice/by-name`.
2. For each slot `a` and `b`, `dd` the partition to `/tmp/boot_<slot>.img`.
3. `adb pull` the image into the backup directory.
4. Delete the temporary file from the device.

This is a **boot-only** backup, not a Nandroid: it does not capture `vbmeta`, `dtbo`, `super`, `system` or `userdata`.

### Verify what you have

```shell
# Header sanity check, should report an Android boot image
file boot_a.img

# Unpack and inspect kernel, ramdisk and dtb
magiskboot unpack boot_a.img
unpack_bootimg --boot_img boot_a.img --out ./boot_a_unpacked
```

If `magiskboot unpack` lists a `ramdisk.cpio` containing `system/bin/recovery`, that boot image carries the recovery ramdisk.

### Restoring

- Match each slot: flash `boot_a.img` to `boot_a` and `boot_b.img` to `boot_b`. After a partial OTA the two slots can differ, and cross-flashing them can break the next update or the boot.
- Flash to the inactive slot, then switch slots:

  ```shell
  fastboot --set-active=b
  fastboot flash boot_a ./oneplus_nord/backup/boot_a.img
  ```

- Restoring stock `boot` removes Magisk, because root lives in the patched ramdisk. It does **not** relock the bootloader (see `lock.sh`).

## 🧩 What is `vbmeta`?

`vbmeta` is the manifest partition of **Android Verified Boot (AVB 2.0)**. It contains no executable code: it holds the signature and the hash descriptors that let the bootloader verify every other partition.

### The chain of trust

```
hardware root of trust (OEM key in eFuse)
  └─ bootloader
       └─ vbmeta  ← signed by the OEM key
            ├─ descriptor: boot      (hash / hashtree root)
            ├─ descriptor: dtbo
            ├─ descriptor: system    (hashtree)
            └─ descriptor: vendor, product, …
```

At boot, the bootloader checks the `vbmeta` signature, then uses its descriptors to hash-check each partition before executing it. Any mismatch means the boot stops with *"Your device is corrupt"* or a `dm-verity` loop.

### What the image holds

| Field                    | Purpose                                                                                  |
| ------------------------ | ---------------------------------------------------------------------------------------- |
| **Header**               | AVB version, signing algorithm (`SHA256_RSA2048` / `SHA256_RSA4096`), rollback index     |
| **Authentication block** | Signature over the descriptors and the public key                                        |
| **Public key**           | The OEM key the bootloader pins                                                          |
| **Descriptors**          | Hash or hashtree entries for `boot`, `dtbo`, `system`, `vendor`, … plus chain partitions |
| **Flags**                | `HASHTREE_DISABLED` and `VERIFICATION_DISABLED`                                          |

Larger devices split it further: `vbmeta_system` and `vbmeta_vendor` are chained from `vbmeta`, and on A/B devices the partition itself is slotted (`vbmeta_a` / `vbmeta_b`). `fastboot` targets the active slot automatically.

### Why rooting needs it

Magisk patches `boot`, which changes its hash. `vbmeta` still carries the **stock** hash, so the bootloader rejects the modified image. Flashing a `vbmeta` with the verification flags cleared tells the bootloader to skip those checks:

```shell
fastboot --disable-verity --disable-verification flash vbmeta \
  ./oneplus_nord/vbmeta.img
```

`flash_vbmeta` wraps exactly this through `_flash_img`, using the `vbmeta` option (default `./oneplus_nord/vbmeta.img`). Its documentation calls it *"Disable boot verification — AVB fix bootloop"*: that is the standard repair when a patched boot leaves the device stuck before the boot animation.

The same result is sometimes obtained by flashing an **empty** `vbmeta` image, which carries no descriptors, but the flag method above is the one used here.

### Caveats

- Disabling AVB is a **security downgrade**: the bootloader no longer detects tampering in the covered partitions. It is what allows a patched boot and custom recovery to persist.
- Only do this with an **unlocked** bootloader.
- To return to a fully verified device, restore the stock `boot` **and** stock `vbmeta`, then relock (see `lock.sh`). Relocking with a patched boot or a modified `vbmeta` will refuse to boot.

## 📚 Related commands

| Command                 | Purpose                                                    |
| ----------------------- | ---------------------------------------------------------- |
| `download_oneplus_nord` | Fetch the Magisk APK and PBRP image, verified with SHA-256 |
| `unlock_oneplus_nord`   | Unlock the bootloader (erases user data)                   |
| `root_oneplus_nord`     | Boot PBRP, back up both boot slots, flash Magisk           |
| `toggle_active_slot`    | Switch the active A/B slot                                 |
| `flash_vbmeta`          | Flash a `vbmeta` image (needed to disable verification)    |
| `lock`                  | Relock the bootloader once stock images are restored       |
| `unbrick`               | Sideload an OTA or flash individual partitions             |
