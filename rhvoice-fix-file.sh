INPUT=

if [ ! -t 0 ]; then
  #echo "(pipe has data)"

  INPUT=$(< /dev/stdin)
else
  #echo "(no pipe)"
  INPUT="$@"
fi


TEMP_FILE_PATH_PART=$(mktemp)

TEMP_FILE_PATH_INPUT="$TEMP_FILE_PATH_PART"
TEMP_FILE_PATH_OUTPUT="$TEMP_FILE_PATH_PART.output"

echo "$INPUT" > "$TEMP_FILE_PATH_INPUT"
cat "$TEMP_FILE_PATH_INPUT" > "$TEMP_FILE_PATH_OUTPUT"

# Произношение
sed -i 's/мистер/мистэр/I' "$TEMP_FILE_PATH_OUTPUT"

# Ударения
sed -i 's/помочь/пом+очь/I' "$TEMP_FILE_PATH_OUTPUT"

cat "$TEMP_FILE_PATH_OUTPUT"

rm -f "$TEMP_FILE_PATH_INPUT"
rm -f "$TEMP_FILE_PATH_OUTPUT"


