swift package --allow-writing-to-directory docs \
    generate-documentation --target Calligraphy \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path vsanthanam \
    --output-path docs