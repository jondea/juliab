# juliab: Julia with batteries included

A user friendly way to solve the TTFP (Time To First Plot) problem.
In more words: an easy and non-destructive way to reduce the time from starting
Julia to doing useful work.

## How to install and use

Simply download and add this folder to your path, then type
```sh
juliab
```

Follow the instructions, wait for it to compile, then next time you want to use
Julia, type
```sh
juliab
```
again, and away you go!

If you ever want to use plain old Julia without the batteries, then type `julia`
and you will find it is unchanged.
If you are feeling particularly brave, you could symlink or alias `julia` to
`juliab`.

Note that the more packages you load, the slower you `juliab` will startup,
so you should only add packages and functions you use most often.

Also note that when you run Pluto, the default sysimage is used.
To use the `juliab.so` sysimage, see instructions
[here](https://github.com/fonsp/Pluto.jl/wiki/Using-sysimage-with-Pluto).

## `juliab` in action

How much difference does it make?
```sh
time julia -e 'using Plots; plot(randn(5)); savefig("rand_fig.png");'
real	0m13.371s
user	0m12.906s
sys	0m0.992s
```

After the first run (providing you include the `Plots` package)
```sh
time juliab -e 'using Plots; plot(randn(5)); savefig("rand_fig.png");'
real	0m0.850s
user	0m0.882s
sys	0m0.822s
```

The time to first plot has gone from ~13 seconds to under 1!
The difference is even more noticeable if you use Julia to do small tasks from
the command line.

Note: timings from a 2019 i5 laptop.

## How it works

`juliab` is essentially a thin wrapper around
[PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl),
taking you through the process of creating a sysimage for your specific needs.
The first time `juliab` runs, it builds a sysimage with the packages you want,
using a precompile execution and statement file for each package and
category.
Before it does that, it also adds and updates the requested packages.

`juliab` runs the setup/compile if it doesn't detect a `juliab.so`.
Delete this if you want to recreate your sysimage.

## Advanced usage and extending

The precompile files need considerable padding out to make them more useful.
In particular, you should call any functions that you use particularly often.
The category and package list is defined in `create_juliab_so.jl`, and it is
easy to add your own.
If you add packages or precompile files that you think others might find
useful, please create a pull request!
