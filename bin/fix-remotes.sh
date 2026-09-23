cat > /tmp/fix-remotes.sh <<'EOF'
#!/usr/bin/env bash
set -u

DRY=1

read -r -p "Check all repos under $PWD? [y/N] " ans
case "$ans" in
  y|Y) ;;
  *) echo "aborted"; exit 1 ;;
esac

for pair in "ocodo:ocodo-labs" "jasonm23:ocodo"; do
  old=${pair%%:*}
  new=${pair##*:}

  echo "### $old -> $new"

  find "$PWD" -maxdepth 6 -type d -name .git -prune -print0 2>/dev/null |
  while IFS= read -r -d '' d; do
    cd "$d/.." || continue
    git remote |
    while IFS= read -r r; do
      url=$(git remote get-url "$r")
      case "$url" in
        "git@github.com:$old/"*|"https://github.com/$old/"*)
          newurl=$(printf '%s' "$url" | sed "s|github\.com:$old/|github.com:$new/|; s|github\.com/$old/|github.com/$new/|")
          if [ "$DRY" = "1" ]; then
            echo "DRY  $PWD  $r  $url -> $newurl"
          else
            echo "SET  $PWD  $r  $url -> $newurl"
            git remote set-url "$r" "$newurl"
          fi
          ;;
      esac
    done
  done
done
EOF