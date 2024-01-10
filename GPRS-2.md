# GitRepublic Protocol Specification 2: Proposing and Discussing Changes to Third-Party Objects

This specification defines how Nostr events are to be used to propose and discuss changes to signed and versioned third-party objects described by [[GRPS-1]].  Existing NIP standards are used insofar as possible, but new event kinds are defined to avoid cluttering social media feeds.

## Kind `12001`: Simple Comment

An event of kind `12001` SHALL be used to broadcast a comment related to a signed (and possibly versioned) third-party object represented by kinds `32000` and `32001`.  This event kind SHALL adhere to the standards for kind `1` text notes defined by [NIP-01](https://github.com/nostr-protocol/nips/blob/master/01.md), with the following modifications:

- Kind `12001` comments SHOULD only be used as responses to existing events related to authenticating third-party objects.
- Since kind `12001` is a replaceable event, clients SHOULD support content editing of kind `12001` comments.
- An `a` tag MUST reference an event of kind `32000`, `32001`, `32023`, or `32084`.
- An `e` tag MAY reference a kind `12001` event as a preceding comment in a thread, as defined in [NIP-10](https://github.com/nostr-protocol/nips/blob/master/10.md).

## Kind `32023`: Change Request

An event of kind `32023` SHALL be used to propose changes to a versioned third-party object authenticated by kind `32001` events.  Kind `32024` SHALL be used to store drafts of change requests.  Both event kinds SHALL adhere to the [NIP-23](https://github.com/nostr-protocol/nips/blob/master/23.md) specification for long-form content.

## Kind `32084`: Content Highlights

An event of kind `32084` SHALL be used to comment on a specific part of a third-party object signed by a kind `32000` or `32001` event.  The event SHALL adhere to the [NIP-84](https://github.com/nostr-protocol/nips/blob/master/84.md) specification for highlights, with the following particularities:

- The `content` field MUST include the highlighted content.
- The `r` tag MUST be used to indicated one or more locations at which the highlighted content can be found.  When possible, the URL given in the tag SHOULD include a content section or line number for greater specificity.
- An `a` tag MUST point to a kind `32000` or `32001` event authenticating the highlighted content.
- An `a` tag MAY point to a kind `32023` event.  In such a case, the client SHOULD represent the kind `32084` highlight in a thread associated with the kind `32023` change request.
- An `a` tag MAY point to a kind `12001` event.  The referenced event SHOULD be represented by the client as a comment on the highlighted content.  Clients SHOULD interpret a referenced kind `12001` event that contains a diff representation as a suggested change to the highlighted content.
- The `p` tag MUST be used to tag the npub that signed the referenced kind `32000` or `32001` event.  Other `p` tags MAY be included to tag other relevant npubs.

## Usage Notes

The standards outlined in this specification are intended to form the basis of a GitHub-like system for discussing changes to versioned objects.  In such a scheme, kind `32023` would represent a pull request (and kind `32024` a draft PR).  Kind `32084` would be used to comment on specific lines of code in a PR, with the `r` tag pointing to the lines of interest on a file blob.  Kind `12001` would be used to add comments or responses to change requests or highlights, or even to individual commits (represented by kind `32000` and `32001` events).
