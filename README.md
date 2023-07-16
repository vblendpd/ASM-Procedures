A collection of MSVC 64-bit assembly procedures used for educational purpose. Each procedure is carefully commented.\
`masm(.targets, .props)` should be added to the project build customizations and "C" linkage must be used to link:
```c
extern "C" int gcd(int a, int b);

void Func()
{
  const auto x = gdc(12, 24);
}
```
A procedure ending with `_a` `_b` etc. provides an alternative solution to the same problem.
