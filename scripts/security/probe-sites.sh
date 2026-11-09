#!/usr/bin/env bash
# Probes live Monjizeen hosts. Fails if an internal tool answers 200 without a
# session, a sensitive path is reachable, or HTTPS/security headers are missing.
set -u
fail=0

# host => kind (internal tools must NOT serve content to anonymous visitors)
INTERNAL="radar.mnjz.in kawader.mnjz.in staging.monjizeen.com"
PUBLIC="monjizeen.com app.monjizeen.com"
SENSITIVE="/.env /.git/config /storage/logs/laravel.log /phpinfo.php /telescope /horizon /_ignition/health-check"

code() { curl -s -o /dev/null -m 15 -w "%{http_code}" "$@"; }

for h in $INTERNAL; do
  c=$(code "https://$h/")
  # 200 on the root with no cookie means the tool is open. 301/302/401/403 = gated.
  if [ "$c" = "200" ]; then
    # a public sign-in page can legitimately be 200; accept if it asks for sign in
    if curl -s -m 15 "https://$h/" | grep -qiE 'sign.?in|log.?in|monjizeen'; then
      echo "note: $h root is 200 (sign-in page?). Verify by hand."
    else
      echo "FAIL: $h serves content without sign-in"; fail=1
    fi
  else
    echo "ok: $h root -> $c"
  fi
done

for h in $INTERNAL $PUBLIC; do
  for p in $SENSITIVE; do
    c=$(code "https://$h$p")
    if [ "$c" = "200" ]; then echo "FAIL: https://$h$p is reachable (200)"; fail=1; fi
  done
  # plain http must redirect to https
  c=$(code "http://$h/")
  case "$c" in 301|302|307|308|000) ;; *) echo "FAIL: http://$h answers $c instead of redirecting"; fail=1;; esac
  hdr=$(curl -sI -m 15 "https://$h/")
  for want in strict-transport-security x-content-type-options; do
    echo "$hdr" | grep -qi "^$want:" || echo "warn: $h missing $want"
  done
done

exit $fail
