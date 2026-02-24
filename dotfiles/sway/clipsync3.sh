#!/bin/sh
# Scan for wlroots and x11 primary selection and clipboard events and synchronize between them
# Requirements:
#  clipnotify   https://github.com/cdown/clipnotify (xfixes clipboard events)
#  wl-clipboard https://github.com/bugaevc/wl-clipboard
#  xclip        https://github.com/astrand/xclip
#  sha256sum    coreutils

# multi-TARGET/mimetype negotiation requires a more complicated protocol
# bridge than what xclip and wl-clipboard can be expected to provide.
# To see the scope of the problem for a given selection:
#   xclip -o -t TARGETS
#   wl-paste --list-types
# Instead, we naively prioritize top-to-bottom from the following list that
# you're welcome to modify to suit your needs:

TYPEPRIORITY="
image/png
image/tiff
text/plain;charset=utf-8
UTF8_STRING
text/plain
STRING
"

set -e

# "list targets/types" commands
wpt() { wl-paste          --primary --list-types; };
wct() { wl-paste                    --list-types; };
xpt() { xclip -o -selection primary   -t TARGETS || true; }; # see xclip note at bottom
xct() { xclip -o -selection clipboard -t TARGETS || true; };

# "paste from" commands
# note: binary data must go through STDIO; ARGV and ENV are both NUL-delimited
wpp() { wl-paste -n       --primary   -t "$TYPE"; }
wcp() { wl-paste -n                   -t "$TYPE"; }
xpp() { xclip -o -selection primary   -t "$TYPE"; }
xcp() { xclip -o -selection clipboard -t "$TYPE"; }

# "copy into" commands
wpc() { wl-copy        --primary   -t "$TYPE"; }
wcc() { wl-copy                    -t "$TYPE"; }
xpc() { xclip -selection primary   -t "$TYPE"; }
#xcc() { xclip -selection clipboard -t "$TYPE"; } # why is this broken?
xcc() { true; }

fifo="${XDG_RUNTIME_DIR:-/tmp}/clipsync-$WAYLAND_DISPLAY-$DISPLAY.sock"
mkfifo   "$fifo" # unified event stream to prevent multi-process feedback loops

# ensure we kill our whole subprocess group on shutdown
cleanup() { rm "$fifo"; kill -- -$$; }
trap "trap - TERM; cleanup;" INT TERM EXIT # rewrite trap so it doesn't recurse

exec 3<> "$fifo" # open as fd 3
#rm       "$fifo" # we don't technically use the link anymore, but it *is* useful as lockfile

# Event generation commands
wl-paste --primary --watch        echo wp       >&3 & wppid=$!; read -r spam <&3; unset spam
wl-paste           --watch        echo wc       >&3 & wcpid=$!; read -r spam <&3; unset spam
while clipnotify -s primary  ; do echo xp; done >&3 & xppid=$!
#while clipnotify -s clipboard; do echo xc; done >&3 & xcpid=$! # why is this broken?

# Event processing
while read -r event <&3; do
  case "$event" in
    ([wx][pc]) # wayland or x11, primary or clipboard
      TYPES="$( ${event}t )" &&
      [ -n "$TYPES" ] && # GIMP X11 GDK likes doing zero-length selections with no targets
      for TYPE in $TYPEPRIORITY; do
        if [ -z "${TYPES##*$TYPE*}" ]; then   # matching type/target?
          new="$( ${event}p | sha256sum )" && # new sum
          [ x"$new" != x"$old" ]           && # different from old sum?
          for sink in wp wc xp xc; do
            [ "$event" != "$sink" ]        && # avoid sinking into the source
            ${event}p | ${sink}c
          done
          break;                              # always break on matched type/target
        fi
      done;;
    (*)  echo "ERROR: INVALID EVENT ON FD 3: $event"; exit 1; ;;
  esac
  old="$new"
done

# Notes:
# xclip returns 1 on a failure to return TARGETS (such as with -selection clipboard)...
#     000:<:000d: 24: Request(24): ConvertSelection requestor=0x00a00001 selection=0xf9("CLIPBOARD") target=0xf5("TARGETS") property=0x16a("XCLIP_OUT") time=CurrentTime(0x00000000)
#     000:>:000d: Event (generated) SelectionNotify(31) time=CurrentTime(0x00000000) requestor=0x00a00001 selection=0xf9("CLIPBOARD") target=0xf5("TARGETS") property=None(0x0)
#     000:<:000e: 20: Request(16): InternAtom only-if-exists=false(0x00) name='UTF8_STRING'
#     000:>:000e:32: Reply to InternAtom: atom=0x128("UTF8_STRING")
#     Error: target TARGETS not available
# ...and also returns 1 on a failure to resolve what TARGETS were returned (such as with Twibright links2 text selections), regardless of how many successful resolutions have been printed...
#     000:<:000c: 24: Request(24): ConvertSelection requestor=0x00c00001 selection=0x1("PRIMARY") target=0xf5("TARGETS") property=0x16a("XCLIP_OUT") time=CurrentTime(0x00000000)
#     000:>:000c: Event (generated) SelectionNotify(31) time=CurrentTime(0x00000000) requestor=0x00a00001 selection=0x1("PRIMARY") target=0xf5("TARGETS") property=0x16a("XCLIP_OUT")
#     000:<:000d: 24: Request(20): GetProperty delete=false(0x00) window=0x00a00001 property=0x16a("XCLIP_OUT") type=any(0x0) long-offset=0x00000000 long-length=0x00000000
#     000:>:000d:32: Reply to GetProperty: type=0x4("ATOM") bytes-after=0x0000000c data=;
#     000:<:000e: 24: Request(20): GetProperty delete=false(0x00) window=0x00a00001 property=0x16a("XCLIP_OUT") type=any(0x0) long-offset=0x00000000 long-length=0x0000000c
#     000:>:000e:44: Reply to GetProperty: type=0x4("ATOM") bytes-after=0x00000000 data=0xf5("TARGETS"),0x128,0x7f5ad23c;
#     000:<:000f: 12: Request(19): DeleteProperty window=0x00a00001 property=0x16a("XCLIP_OUT")
#     000:<:0010: 20: Request(16): InternAtom only-if-exists=true(0x01) name='text/html'
#     000:>:0010: Event PropertyNotify(28) window=0x00a00001 atom=0x16a("XCLIP_OUT") time=0x019bbed6 state=Deleted(0x01)
#     000:>:0010:32: Reply to InternAtom: atom=0x19a("text/html")
#     TARGETS
#     000:<:0011:  8: Request(17): GetAtomName atom=0x128(unrecognized atom)
#     000:>:0011:44: Reply to GetAtomName: name='UTF8_STRING'
#     UTF8_STRING
#     000:<:0012:  8: Request(17): GetAtomName atom=0x7f5ad23c(unrecognized atom)
#     000:>:0012:Error 5=Atom: major=17, minor=0, bad=0x7f5ad23c, seq=0012
# ...which means we have to blindly try to use its output regardless of exit code.

# Repeatedly using "paste from" on remote X11 servers is pretty horrifying,
# but finding a secure spot to cache NUL-containing data is annoyingly
# system-specific, "od | while read do printf" as a workaround, meanwhile,
# is bafflingly slow. POSIX shell is just not good at this job.

# if further process management is needed:
#kill   $wcpid $wppid $xppid $xcpid
#disown $wcpid $wppid $xppid $xcpid
