#!/bin/sh

# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.
#
# SPDX-License-Identifier: MIT

# This scripts executes a findutils script to search for Copyright years
# in all files and update them

find . -type f \( -not -path './.git*' \) \( \(\
    -exec grep -P 'Copyright \(c\) \d{4}' {} \; \
    -exec sed -i 's/\(Copyright (c) \)[[:digit:]]\{4\}/\1'"$(date +%Y)"'/g' {} \; \
    -exec echo Modified date for {} \; \
    \) -o -exec echo {} not affected \; \)
