#!/bin/bash

VNAME="Diving_10s"
TILE_YUV_PATH="${VNAME}/erp_4x3/tile_yuv"	#change here
TILE_LOG_PATH="${VNAME}/erp_4x3/tile_log"	#change here
W_yuv=3840
H_yuv=1920
No_tile_W=4                             	    	
No_tile_H=3        
W_TILE=960                              		#W_yuv/No_tile_W  
H_TILE=640						#H_yuv/No_tile_H 
FRAME_RATE=30
QP_LIST=(38 32 28 24 20)

mkdir -p "${TILE_LOG_PATH}"

for tile in "${TILE_YUV_PATH}"/tile_*.yuv; do
    if [[ ! -f "$tile" ]]; then
        echo "Can not find .yuv in  ${TILE_YUV_PATH}"
        exit 1
    fi

    for QP in "${QP_LIST[@]}"; do
        BASENAME=$(basename "${tile%.yuv}")
        OUTPUT="${TILE_YUV_PATH}/${BASENAME}_QP${QP}.bin"
        LOG="${TILE_LOG_PATH}/log_encode_${BASENAME}_QP${QP}.txt"

        echo "Encoding ${tile} with QP=${QP}"
        x265 --input "${tile}" \
             --input-res "${W_TILE}x${H_TILE}" \
             --fps "${FRAME_RATE}" \
             --frames 300 \
             --qp "${QP}" \
             --preset medium \
             --output "${OUTPUT}" \
             > "${LOG}" 2>&1

        if [[ $? -eq 0 ]]; then
            echo "Finishing encoding ${OUTPUT}"
        else
            echo "Error encoding ${tile} with QP=${QP}, check log: ${LOG}"
            exit 1
        fi
    done
done

echo "Finish encoding"
