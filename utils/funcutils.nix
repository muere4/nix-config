# utils/funcutils.nix
{
  flip  = f: b: a: f a b;
  const = defaultValue: any: defaultValue;
}
