<a href="https://github.com/yuzhouwww/Blockies">
  <p align="center">
    <img src="blockies.png" width="25%" align="center">
  </p>
</a>

# Blockies

This library is an Objective-C implementation of the [Ethereum fork of Blockies](https://github.com/ethereum/blockies) which is intended to be used in iOS, watchOS, tvOS and macOS apps. And the code is literally translated from [BlockiesSwift](https://github.com/Boilertalk/BlockiesSwift).

Blockies generates unique images (identicons) for a given seed string. Those can be used to create images representing an Ethereum (or other Cryptocurrency) Wallet address or really anything else.

# Installation

Clone this repo and drag Blockies.* to your project.

# Usage

```objective-c
#import "Blockies.h"

UIImage *image = [Blockies getImgWithSeed:@"n1RZfatTFvkXPUa8M9bGJyV8AZmjLQZQzrt"];
```

# Author

Zhou Yu, yuzhouwww@gmail.com

# License

Blockies is available under the MIT license. See the LICENSE file for more info.
