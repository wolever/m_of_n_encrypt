#!/bin/sh

# So, flag on argument for each key_id to include
# Flag to set how many keys of given ones are needed to decrypt
# Flag to set payload files. - or none is stdin.
#  Multiple files are each encrypted into their own blocks

# Roughly, for each key, for each other key, until you get to (m-1) you encrypt the payload to the rest of the keys.
# Then you encypt that to the higher key, and bundle all of those together with tar, and encrypt that to the higher, etc.
# At the top level you end up with a bunch of files, one for each user, that they can decrypt to get a tarball.
# That tarball contains a similar encrypted file for each other key.
# When given to that person, they can decrypt it to get another tarball to give to any of the others (not including the first)
# The second last person gets a single file that can be decrypted by any of the people who weren't in the path leading to that file.

keys=""
inputs=""
n=""

usage() {
	(
	printf "Encrypts given payloads to given keys, such that any N of them could decrypt the payload, but not less.\n"
	printf "  -n NUM   Number of keys required to decrypt the payloads\n"
	printf "  -r ID    Key ID of one of the recipients. Can be anything gpg understands\n"
	printf "  -f FILE  File to encrypt. If FILE is -, read from stdin\n"
	printf "           If multiple files are given, each of them are encrypted as separate blobs\n"
	printf "  If no files are given, stdin is assumed.\n"
	printf "  Other options must be specified. There must be more than NUM IDs given\n"
	) >&2
}

usage

