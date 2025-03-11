#!/bin/bash

SESSION_NUMBER=$1  # Parameter pertama: nomor sesi
URL=$2             # Parameter kedua: URL video
KEY=$3             # Parameter ketiga: Stream Key
DURATION=$4        # Parameter keempat: Durasi streaming

case $SESSION_NUMBER in
  1)
    SESI="stream1"
    ;;
  2)
    SESI="stream2"
    ;;
  3)
    SESI="arab1"
    ;;
  4)
    SESI="arab2"
    ;;
  5)
    SESI="testing"
    ;;
  *)
    echo "Session number tidak valid."
    exit 1
    ;;
esac

echo "SESI: $SESI"
echo "URL: $URL"
echo "KEY: $KEY"
echo "DURATION: $DURATION"

tmux new-session -d -s "$SESI"
tmux send-keys -t "$SESI" "bash" C-m
tmux send-keys -t "$SESI" "durasi=$DURATION" C-m
tmux send-keys -t "$SESI" "waktu_mulai=\$(date +%s)" C-m
tmux send-keys -t "$SESI" "local_file=\"${SESI}.mp4\"" C-m  # Nama file menyesuaikan SESI
tmux send-keys -t "$SESI" "URL_share=\"$URL\"" C-m
tmux send-keys -t "$SESI" "stream_key=\"$KEY\"" C-m
tmux send-keys -t "$SESI" "download_file() {" C-m
tmux send-keys -t "$SESI" "  local url=\"\$1\"" C-m
tmux send-keys -t "$SESI" "  local output_file=\"\$2\"" C-m
tmux send-keys -t "$SESI" "  echo \"Mengunduh file dari: \$url\"" C-m
tmux send-keys -t "$SESI" "  curl -L \"\$url\" -o \"\$output_file\"" C-m
tmux send-keys -t "$SESI" "  if [ \$? -ne 0 ]; then" C-m
tmux send-keys -t "$SESI" "    echo \"Gagal mengunduh file.\"" C-m
tmux send-keys -t "$SESI" "    exit 1" C-m
tmux send-keys -t "$SESI" "  fi" C-m
tmux send-keys -t "$SESI" "  echo \"File berhasil diunduh ke: \$output_file\"" C-m
tmux send-keys -t "$SESI" "}" C-m
tmux send-keys -t "$SESI" "file_id=\$(echo \"\$URL_share\" | grep -oP '(?<=/file/d/)[^/]+' )" C-m
tmux send-keys -t "$SESI" "URL_download=\"https://drive.usercontent.google.com/download?id=\$file_id&confirm=t\"" C-m
tmux send-keys -t "$SESI" "download_file \"\$URL_download\" \"\$local_file\"" C-m
tmux send-keys -t "$SESI" "while true; do" C-m
tmux send-keys -t "$SESI" "  waktu_sekarang=\$(date +%s)" C-m
tmux send-keys -t "$SESI" "  selisih_waktu=\$((waktu_sekarang - waktu_mulai))" C-m
tmux send-keys -t "$SESI" "  if ((selisih_waktu >= durasi)); then" C-m
tmux send-keys -t "$SESI" "    echo \"Durasi yang ditentukan telah tercapai. Menghentikan streaming.\"" C-m
tmux send-keys -t "$SESI" "    break" C-m
tmux send-keys -t "$SESI" "  fi" C-m
tmux send-keys -t "$SESI" "  ffmpeg -re -i \"\$local_file\" -c copy -f flv rtmps://a.rtmp.youtube.com/live2/\$stream_key" C-m
tmux send-keys -t "$SESI" "  sleep 5" C-m
tmux send-keys -t "$SESI" "done" C-m