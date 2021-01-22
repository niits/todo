IFS=, read -d '' -a files <<<$(git diff --name-only HEAD HEAD~1)

buildapi=false
buildweb=false

function build_api() {
    echo "Build api image:"
    # @todo build api image and push it to docker hub
}

function build_web() {
    echo "Build web image:"
    # @todo build web image and push it to docker hub
}
for word in $files; do
    case $(echo $word | cut -d "/" -f1 -) in
    api) buildapi=true ;;
    web) buildweb=true ;;
    esac
done

if $buildapi; then
    build_api
fi

if $buildweb; then
    build_web
fi
