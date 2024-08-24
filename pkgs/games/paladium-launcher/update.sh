#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused
set -euo pipefail

target="$(dirname "$(readlink -f "$0")")/info.json"
host="https://download.paladium-pvp.fr"
bootstrap=$(curl "$host/games/bootstrap.json")
url=$(echo "$bootstrap" | jq .launcher.LINUX.url -r)
oldVersion=$(jq -r '.version' "$target")
version=$(echo "$bootstrap" | jq .version -r)

if [ "$oldVersion" != "$version" ]; then
    nix store prefetch-file "$url" --json -L -v | jq --arg version "$version" --arg url "$url" '.version = $version | .url = $url' > "$target"
    unzip "$(cat $target | jq .storePath -r)" build_meta.json

    echo "Updating jcef build meta"

    releaseTag="$(jq .release_tag build_meta.json -r | sed 's|^jcef-{7}\+cef||')"
    jcefURL="$(jq .jcef_url build_meta.json -r)"

    jcefTarget="$(dirname "$(readlink -f "$0")")/jcef_info.json"

    regex='https:\/\/bitbucket\.org\/\(.*\)\/\(.*\)\/commits\/\(.*\)'

    owner="$(echo "$jcefURL" | sed "s|$regex|\1|")"
    repo="$(echo "$jcefURL" | sed "s|$regex|\2|")"
    rev="$(echo "$jcefURL" | sed "s|$regex|\3|")"
    cefBuild="$(echo "$releaseTag" | tail -c +18)"
    jcefRelease="$(echo "$releaseTag" | sed 's|\+cef.*$||')"

    cat build_meta.json | jq '.nix = $ARGS.named' \
        --arg owner "$owner" \
        --arg repo "$repo" \
        --arg rev "$rev" \
        --arg cefBuild "$cefBuild" \
        --arg jcefRelease "$jcefRelease" > "$jcefTarget"

    rm build_meta.json
else
    echo "Paladium Launcher is up to date."
fi
