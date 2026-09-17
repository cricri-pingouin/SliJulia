# SliJulia
Draw a Julia or Mandelbrot set fractal, with customisable colour palette and ability to save to PNG. Written in Turbo Delphi (using scanline).
Replaces [SliFractal](https://github.com/cricri-pingouin/SliFractal).

<ins>New features:</ins>
- Fixed X <-> Y bug that produced rendering artefacts if canvas height and width were not equal (doh!). Took a while to even notice!
- Added customisable 3 colours palette
- Now can render either a Julia or Mandelbrot set.

<ins>Will I do an asm version?</ins>

If you check the Unit1.pas code, you'll find a section ins asm that has been commented out. I did start working on it and just lost interest before I got it working properly. Last time it took me way too long and it just wasn't worth the effort. If you want to check this previous effort, check [SliFractalAsm](https://github.com/cricri-pingouin/SliFractalAsm), but be aware that it won't be updated anymore, and it doesn't include some of the fixes/updates from this newer repository.
