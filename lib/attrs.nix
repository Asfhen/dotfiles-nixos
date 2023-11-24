{ lib, ... }:

with builtins;
with lib;
rec {
  attrsToList = attrs: mapAttrsToList(name: value: { inherit name value; }) attrs;
  mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);
  genAttrs' = values: f: listToAttr (map f values);
  anyAttrs = pred: attrs: any (attr: pred attr.name attr.value) (attrsToList attrs);
  countAttrs = pred: attrs: count (attr: pred attr.name attr.value) (attrsToList attrs);
}