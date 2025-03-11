#!/bin/sh
set -ex

TS=$(date +%s)

TOPIC_ROOT=$(tedge config get mqtt.topic_root)
TOPIC_ID=$(tedge config get mqtt.device_topic_id)

publish_basic() {
    RAW_VALUE=$(echo "$TS % 60" | bc)
    PAYLOAD=$(printf '{"time":%s,"sensor":{"counter":%d}}' "$TS" "$RAW_VALUE")
    tedge mqtt pub -q 1 "${TOPIC_ROOT}/${TOPIC_ID}/m/sensor" "$PAYLOAD"
}

publish_conditional() {
    RAW_VALUE=$(echo "$TS % 15 > 2" | bc)

    if [ "$RAW_VALUE" = "1" ]; then
        PAYLOAD=$(printf '{"time":%d,"severity":"major","text":"Problem found, please schedule a site visit ASAP"}' "$TS")
        tedge mqtt pub -r -q 1 "${TOPIC_ROOT}/${TOPIC_ID}/a/schedule_req" "$PAYLOAD"
    else
        tedge mqtt pub -r -q 1 "${TOPIC_ROOT}/${TOPIC_ID}/a/schedule_req" ""
    fi
}

COMMAND="$1"
shift

case "$COMMAND" in
    basic)
        publish_basic
        ;;
    conditional)
        publish_conditional
        ;;
    *)
        echo "Unknown command" >&2
        exit 1
        ;;
esac
