# GitRepublic Protocol Specification 1: Signed Third-Party Objects

This specification defines a protocol by which Nostr events may be used to sign third-party objects.  With Nostr, the cryptographic identity afforded by an npub/nsec keypair can be used to verify the authenticity of an object accessible via some third-party server or protocol.  Such objects may include, but certainly are not limited to, Git commits, files, and images.  The level of trust a user gives to a given npub may, by extension, be given to third-party objects signed by that npub.

## Nostr Event Kinds

Nostr parameterized replaceable events of kinds in the range `32000 <= n < 32099` MAY be used in relation to third-party object signing.  Where possible, these events adhere to standards proposed by existing Nostr Improvement Possibilities (NIPs).  Nostr clients uninterested in signed third-party objects can simply ignore this kind range to avoid cluttering up their event feeds.

### Kind `32001`: Third-Party Object Authentication

### Event Specification

An event of  kind `32001` SHALL serve to authenticate an object hosted by a third-party service (i.e., not a Nostr client or relay).  The `content` field MAY contain a description of the object or its contents.  The following tags SHALL be used:

- The `d` tag MUST contain a unique identifier for the object.  This identifier SHOULD be a hash of the object itself to provide an additional means of validating its authenticity.
- The `r` tag MUST indicate one or more URLs at which the object can be found.
- The `a` tag MAY be used to refer to the kind `32001` event that authenticated the immediately previous version of the object.
- The `m` tag MAY be included to indicate the MIME type of the object.
- The `client` tag, as defined in [NIP-89](https://github.com/nostr-protocol/nips/blob/master/89.md), MAY be included to indicate a preferred client for handling the Nostr event and its associated object.

### Event Format

```json
{
  ...,
  "kind": 32001,
  "tags": [
    ["d", <unique identifier>],
    ["r", <comma-separated urls>],
    ["a", <event id>, <relay hint>],
    ["m", <MIME type>],
    ["client", <name>, <address>, <relay hint>]
  ],
  "content": <arbitrary string>,
  ...
}
```

### Example Usage

One possible usage of this specification is to use a Nostr note to digitally sign a Git commit in a hosted repository.  In this case, the `d` identifier can be the unique SHA-1 hash of the Git commit object, and the `r` tag can be used to indicate one or more URLs that have a copy of the repository containing that commit.  The `a` tag can point to the kind `32001` note that authenticated the previous commit.  The `content` field may contain the commit message itself, information about the commit, branch, or repository; or it may be left blank.

```json
{
  ...,
  "kind": 32001,
  "tags": [
    ["d", "1636e6a2cc7e77cefd8c74719b27bdc59c937c0e"],
    ["a", "32001:npub1s3ht77dq4zqnya8vjun5jp3p44pr794ru36d0ltxu65chljw8xjqd975wz:6bec40bf5ec866b81faf5336579e38b0ad75e167", "wss://relay.damus.io"],
    ["r", "https://github.com/ShadowySupercode/GitRepublic.git"]
  ],
  "content": "Update README.md with Nostr note links",
  ...
}
```

When this event is signed and published, anyone who trusts the publishing npub will have all the information they need to find and fetch the commit, and to use Git to reconstruct the repository history up to the point of that commit. 
