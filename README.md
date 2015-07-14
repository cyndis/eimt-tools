eimt-tools
----------

Three things:

- `uboot_boot.scr` is a simple U-Boot boot script that downloads the kernel,
  DTB and initramfs using TFTP and boots. `build_boot_script.sh` is a script
  that generates a .uimg from the script file. Note that you need to replace
  placeholders in `uboot_boot.scr` with your NFS share's IP and path.
- `build_initramfs.sh` generates an initramfs image that uses NFS to mount the
  rootfs and execute the test script.
- `build_eimt_rootfs.sh` generates a Ubuntu Core-based rootfs with the
  tegra-tests test suite and a test script that automatically runs the tests.

This combination results in a board that can automatically boot itself remotely
and run the test suite.
