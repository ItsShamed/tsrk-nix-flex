{ lib, ... }:

{
  mkIfElse = predicate: positiveValue: negativeValue: lib.mkMerge [
    (lib.mkIf predicate positiveValue)
    (lib.mkIf (!predicate) negativeValue)
  ];
}
