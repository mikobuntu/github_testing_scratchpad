#!/bin/bash

# Configuration
DURATION=60
FILE="recording.wav"
BAR_WIDTH=15  # 15 emojis wide (30 terminal columns approx)

cleanup() {
    echo -e "\n\n🛑 Stopping recording..."
    [ -n "$ARECORD_PID" ] && kill $ARECORD_PID 2>/dev/null
    exit 0
}

trap cleanup INT

while true; do
    echo "⏺️  Recording 60s to $FILE... ($(date +%H:%M:%S))"
    
    # Start arecord in background
    arecord -D plug:default -f cd -d $DURATION $FILE &>/dev/null &
    ARECORD_PID=$!

    for ((i=0; i<=$DURATION; i++)); do
        PERCENT=$(( i * 100 / DURATION ))
        
        # Calculate segments
        NUM_FILLED=$(( i * BAR_WIDTH / DURATION ))
        NUM_EMPTY=$(( BAR_WIDTH - NUM_FILLED ))
        
        # Build the visual bar
        BAR=""
        for ((j=0; j<NUM_FILLED; j++)); do BAR+="🟢"; done
        for ((j=0; j<NUM_EMPTY; j++)); do BAR+="⚪"; done
        
        # Print update
        printf "\r%s %d%% (%ds) " "$BAR" "$PERCENT" "$i"
        
        if kill -0 $ARECORD_PID 2>/dev/null; then
            sleep 1
        else
            break
        fi
    done

    echo -e "\n✅ Cycle complete. Overwriting...\n"
done
