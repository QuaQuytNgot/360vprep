## 📽️ Overview

**360vprep** is a content preparation pipeline for 360-degree video streaming. It supports key processes such as video tiling, ERP (Equirectangular Projection) handling, HEVC encoding, and provides a step-by-step tutorial to help you through the entire workflow.

---

## ⚙️ How to Use

Before getting started, replace `{input}` and `{output}` with the actual names of your video files.

### 1. Install Prerequisites

Make sure your system is up to date and the necessary tools are installed:

```bash
sudo apt update
sudo apt install perl ffmpeg x265
```

### 2. Clone the Repository

Download the source code:

```bash
git clone https://github.com/QuaQuytNgot/360vprep.git
cd 360vprep
```

### 3. (Optional) Trim the Input Video

If you want to trim a specific segment of your video:

```bash
ffmpeg -ss 00:00:30.0 -i input.webm -t 00:00:10.0 output.webm
```

This command starts at 30 seconds into the input and extracts a 10-second clip.

### 4. Tile the Video

Create a folder to store raw YUV files and convert the video:

```bash
mkdir yuv_file
ffmpeg -y -i input.webm -pix_fmt yuv420p yuv_file/output.yuv
```

Then run the tiling script:

```bash
perl split_erp_tiles.pl
```

### 5. Encode with HEVC

Adjust paths and tile configuration parameters (e.g., `W_TILE`, `H_TILE`) in the script as needed. The video will be encoded into 5 layers using QP values `{38, 32, 28, 24, 20}`:

```bash
bash encode_HEVC.sh
```

Check the results of each encoding layer under:

```
{input}/erp_{mxn}/tile_log/
```

---

## 🧾 Notes

- Make sure your input video is in equirectangular projection format.
- You can customize the tiling structure (e.g., 6x4 tiles) in the Perl and shell scripts.
- Results can be used in adaptive 360 video streaming systems.

---

## 📬 Contact

For questions or contributions, please open an issue or submit a pull request on GitHub.

