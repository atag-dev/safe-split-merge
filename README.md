# 📁 safe-split-merge.sh

**Split and merge large files safely with integrity checks (MD5)**

## 🧩 Overview

`safe-split-merge.sh` is a Bash utility that allows you to **split a large file into smaller chunks** and later **merge them back with integrity verification**. This is especially useful in environments with **unstable or slow internet connections**, where uploading or transferring large files in a single go is prone to failure.

By splitting files, you can manually upload smaller parts to your destination and then merge them back reliably. The script uses **MD5 checksums** to verify that the merged file is exactly the same as the original.

---

## 🚀 Features

* Split any large file into fixed-size chunks (in MB)
* Merge previously split chunks into a complete file
* Generate and verify MD5 checksums to ensure file integrity
* Fully safe: stops on any error (`set -euo pipefail`)

---

## 📦 Usage

### 🧩 Split a Large File

```bash
./safe-split-merge.sh split <source_file> <chunk_size_MB> <output_dir>
```

**Arguments:**

* `<source_file>`: Path to the large file to split
* `<chunk_size_MB>`: Desired size of each chunk (in MB)
* `<output_dir>`: Directory to save the chunks and checksum file

**Example:**

```bash
./safe-split-merge.sh split myvideo.mp4 100 split_parts
```

Creates `split_parts/part_0000`, `part_0001`, ..., and `original.md5`.

---

### 🔗 Merge Chunks Back

```bash
./safe-split-merge.sh merge <input_dir> <merged_file>
```

**Arguments:**

* `<input_dir>`: Directory containing the chunk files and the original `.md5`
* `<merged_file>`: Output file to generate after merging

**Example:**

```bash
./safe-split-merge.sh merge split_parts myvideo_reconstructed.mp4
```

Merges all `part_*` files in `split_parts` and verifies against `original.md5`.

---

## ✅ Why MD5 Checks?

The script generates an MD5 checksum during splitting and verifies it during merging to guarantee **bit-for-bit accuracy**. This ensures the merged file is **identical to the original**, protecting against transfer or disk corruption.

---

## ⚠️ Notes

* It uses the `split`, `md5sum`, and standard Bash utilities.
* Ensure you upload/download all parts **without renaming** before merging.

---

## 🛠 Troubleshooting

* **Checksum mismatch?**

  * Ensure all chunk files are present and in order.
  * Verify that no file was truncated or renamed during upload.

---

## 📄 License

This script is open-source and free to use under the [MIT License](https://opensource.org/licenses/MIT).
