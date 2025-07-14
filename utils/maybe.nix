# utils/maybe.nix
let
  func = import ./funcutils.nix;
  list = import ./list.nix;
in
rec {
  just         = x: { isJust = true;  fromJust = x; };
  nothing      = { isJust = false; fromJust = null; };
  isJust       = { isJust, fromJust }: isJust;
  isNothing    = { isJust, fromJust }: !isJust;

  fmap         = f: m:
    if m.isJust then { isJust = true; fromJust = f m.fromJust; }
    else nothing;

  maybeIf      = guard: val: if guard then just val else nothing;
  pure         = just;
  apply        = mf: ma:
    if mf.isNothing || ma.isNothing then nothing
    else just (mf.fromJust ma.fromJust);

  return       = just;

  join         = mm:
    if mm.isJust then mm.fromJust else nothing;

  bind         = m: f: if m.isNothing then nothing else f m.fromJust;
  fromMaybe    = default: m: if m.isJust then m.fromJust else default;
  maybe        = default: f: m: fromMaybe default (fmap f m);

  listToMaybe  = lst: if lst == [] then nothing else just (builtins.head lst);
  maybeToList  = m: if m.isJust then [ m.fromJust ] else [];
  consMaybe    = m: lst: (maybeToList m) ++ lst;
  catMaybes    = vals: list.reverse (builtins.foldl' (func.flip consMaybe) [] vals);
  alternative  = a: b: if a.isJust then a else b;
}
