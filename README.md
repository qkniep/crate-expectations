# riptide

A (not yet) full Rust implementation of the BitTorrent protocol.

## Examples

```rust
let sk = SigningKey::new();
```

## Key Features

### Implemented BitTorrent Enhancement Proposals (BEPs)

- [BEP 3](https://www.bittorrent.org/beps/bep_0003.html): Base BitTorrent Protocol (v1)
- [BEP 5](https://www.bittorrent.org/beps/bep_0005.html): DHT Protocol
- [BEP 6](https://www.bittorrent.org/beps/bep_0006.html): Fast Extension
- [BEP 7](https://www.bittorrent.org/beps/bep_0007.html): IPv6 Tracker Extension
- [BEP 9](https://www.bittorrent.org/beps/bep_0009.html): Magnet Links
- [BEP 10](https://www.bittorrent.org/beps/bep_0010.html): Extension Protocol
- [BEP 12](https://www.bittorrent.org/beps/bep_0012.html): Multitracker Metadata Extension
- [BEP 15](https://www.bittorrent.org/beps/bep_0015.html): UDP Tracker Protocol
- [BEP 23](https://www.bittorrent.org/beps/bep_0023.html): Compact Peer List
- [BEP 27](https://www.bittorrent.org/beps/bep_0027.html): Private Torrents
- [BEP 29](https://www.bittorrent.org/beps/bep_0029.html): μTP
- [BEP 47](https://www.bittorrent.org/beps/bep_0047.html): Padding
- [BEP 48](https://www.bittorrent.org/beps/bep_0048.html): Scrape Tracker Extension
- [BEP 52](https://www.bittorrent.org/beps/bep_0052.html): BitTorrent Protocol v2
- [BEP 53](https://www.bittorrent.org/beps/bep_0053.html): Select-only Magnet URI Extension
- [BEP 55](https://www.bittorrent.org/beps/bep_0055.html): Holepunch Extension

### Other Non-Standard Extensions

- [Upload-only Mode](https://forum.utorrent.com/topic/45946-clarification-of-partial-seeds/#comment-280236)

## Notes

- WARNING: This crate is still under very active development!

## Roadmap

- [ ] Base Protocol
    - [x] bencoding
    - [x] metainfo
    - [x] Magnet Links
    - [x] Compact Peer List
    - [x] HTTP Trackers
    - [ ] P2P Protocol
- [x] UDP Trackers
- [ ] DHT
- [ ] v2 Spec
    - [ ] Fast Extension
    - [ ] Extension Protocol
- [ ] v3 Spec
- [ ] v3.1 Spec

## Authorship

The riptide code was written by Quentin Kniep <hello@quentinkniep.com>.

## License

Contents are licensed under either the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
or [MIT license](http://opensource.org/licenses/MIT) at your option.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the work by you, as 
defined in the Apache-2.0 license, shall be dual licensed as above, without any additional terms or conditions.

## References

[1] Decker, Christian, Raphael Eidenbenz, and Roger Wattenhofer. "Exploring and improving BitTorrent topologies." IEEE P2P 2013 Proceedings. IEEE, 2013. ([ePrint](https://tik-db.ee.ethz.ch/file/4375eb312af05468d27a55661025b93b))

[2] Atlidakis, Vaggelis, Mema Roussopoulos, and Alex Delis. "Changing the unchoking policy for an enhanced BitTorrent." European Conference on Parallel Processing. Berlin, Heidelberg: Springer Berlin Heidelberg, 2012. ([ePrint](https://www.alexdelis.eu/Publications/ARD-EuroPar2012.pdf))

[3] Bharambe, Ashwin R., Cormac Herley, and Venkata N. Padmanabhan. "Analyzing and improving a bittorrent networks performance mechanisms." Proceedings IEEE INFOCOM 2006. 25TH IEEE International Conference on Computer Communications. IEEE, 2006. ([ePrint](https://jmvidal.cse.sc.edu/library/bharambe06a.pdf))

[4] Wang, Liang, and Jussi Kangasharju. "Measuring large-scale distributed systems: case of bittorrent mainline dht." IEEE P2P 2013 Proceeding ([ePrint](https://www.cs.helsinki.fi/u/lxwang/publications/P2P2013_13.pdf))
