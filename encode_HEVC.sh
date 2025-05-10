#!/bin/bash

VNAME="Diving"
W_TILE=960                                # W_yuv / No_tile_W
H_TILE=640                                # H_yuv / No_tile_H
FRAME_RATE=30
FRAMES=30                                 
QP_LIST=(38 32 28 24 20)

find "${VNAME}" -type f -path "*/erp_4x3/tile_yuv/tile_*.yuv" | while read -r tile; do
    if [[ ! -f "$tile" ]]; then
        echo "Cannot find .yuv tile file: $tile"
        continue
    fi

    TILE_DIR=$(dirname "$tile")
    LOG_DIR="${TILE_DIR/\/tile_yuv/\/tile_log}"

    mkdir -p "$LOG_DIR"

    for QP in "${QP_LIST[@]}"; do
        BASENAME=$(basename "${tile%.yuv}")
        OUTPUT="${TILE_DIR}/${BASENAME}_QP${QP}.bin"
        LOG="${LOG_DIR}/log_encode_${BASENAME}_QP${QP}.txt"

        echo "Encoding ${tile} with QP=${QP}"
        x265 --input "$tile" \
             --input-res "${W_TILE}x${H_TILE}" \
             --fps "${FRAME_RATE}" \
             --frames "${FRAMES}" \
             --qp "${QP}" \
             --preset medium \
             --output "$OUTPUT" \
             > "$LOG" 2>&1

        if [[ $? -eq 0 ]]; then
            echo "Finished encoding ${OUTPUT}"
        else
            echo "Error encoding ${tile} with QP=${QP}, check log: ${LOG}"
            exit 1
        fi
    done
done

echo "Finished encoding all tiles."
