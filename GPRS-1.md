# GitRepublic Protocol Specification 1: Signed Third-Party Objects

This specification defines a protocol by which Nostr events may be used to sign third-party objects.  With Nostr, the cryptographic identity afforded by an npub/nsec keypair can be used to verify the authenticity of an object accessible via some third-party server or protocol.  Such objects may include, but certainly are not limited to, Git commits, files, and images.  The level of trust a user gives to a given npub may, by extension, be given to third-party objects signed by that npub.

## Nostr Event Kind Reservation

Nostr parameterized replaceable events of kinds in the range `32000 <= n < 32099` MAY be used in relation to third-party object signing.  Where possible, these events adhere to standards proposed by existing Nostr Improvement Possibilities (NIPs).  Nostr clients uninterested in signed third-party objects can simply ignore this kind range to avoid cluttering up their event feeds.

## Kind `32000`: Simple Third-Party Object

An event of  kind `32000` SHALL serve to authenticate an unversioned object hosted by a third-party service (i.e., not a Nostr client or relay).  The `content` field MAY contain a description of the object or its contents.  The following tags SHALL be used:

- The `d` tag MUST contain a unique identifier for the object.  This identifier SHOULD be a hash of the object itself to provide an additional means of validating its authenticity.
- The `r` tag MUST indicate one or more URLs at which the object can be found.
- The `m` tag MAY be included to indicate the MIME type of the object.
- The `client` tag, as defined in [NIP-89](https://github.com/nostr-protocol/nips/blob/master/89.md), MAY be included to indicate a preferred client for handling the Nostr event and its associated object.

### Event Format

```json
{
  ...,
  "kind": 32000,
  "tags": [
    ["d", <unique identifier>],
    ["r", <comma-separated urls>],
    ["m", <MIME type>],
    ["client", <name>, <address>, <relay hint>]
  ],
  "content": <arbitrary string>,
  ...
}
```

## Kind `32001`: Versioned Third-Party Object

An event of kind `32001` SHALL serve to authenticate a versioned object hosted by a third-party service (i.e., not a Nostr client or relay).  Events of this kind MUST implement the specification for kind `32000`.  Such events SHALL observe the following rules for version management:

- The `a` tag MUST reference the kind `32000` or `32001` event that represents the immediately previous version of the object.
- The `d` tag MUST give as an identifier a hash of the versioned object, so that each version has a unique hash.
- The initial version of an object SHOULD be represented by a kind `32000` event, and all subsequent versions SHOULD by represented by events of kind `32001`.

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

## Usage Notes

This specification is designed to provide the foundations by which file hosting and version control, akin to GitHub or SharePoint, may be implemented on Nostr.

The first instance of any third-party object authenticated with Nostr should be a kind `32000` event, since that kind has no `a` tag antecedent.  If the third-party object or its host location is changed, the changes may be versioned or unversioned.

When the host location of an object changes, the event can simply be replaced with a new event with the same `d` tag, but updated `r` tags.  Likewise, when an object with a simple ID (i.e., not a hash) is updated in-place, the change may be indicated by replacing the kind `32000` event with a new one that has the same `d` tag but a different `content`.

Version control, such as Git or SVN, may be represented on Nostr using kinds `32000` and `32001`.  In such cases, the `d` tag may be the commit or change ID, and commit details may be included in the `content`.  For a fully version-controlled object, the start of that objects history would be represented by a kind `32000` event, and subsequent changes by a series of kind `32001` events, each representing the previous change.  A complete file history may be constructed from such an event sequence.
