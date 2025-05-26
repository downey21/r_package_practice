# r_package_practice

This repository demonstrates how to build an R package from scratch. It is intended as a comprehensive, annotated example for learning purposes. It includes:

- Package directory structure and required files
- R functions with roxygen2 documentation
- C++ integration via Rcpp
- Inclusion of example data
- Vignette creation
- Use of internal functions
- Export and documentation control
- Compilation flags via Makevars
- Cross-version compatibility considerations

## Directory Structure and File Purposes

```
r_package_practice/
├── data/
│   └── example_data.rda
├── R/
│   ├── example_data.R
│   ├── init.R
│   ├── my_functions.R
│   └── rPracticePkg-package.R
├── src/
│   ├── example.cpp
│   ├── Makevars
│   └── Makevars.win
├── vignettes/
│   ├── rPracticePkg.Rmd
│   └── styles.css
├── .gitignore
├── .Rbuildignore
├── DESCRIPTION
├── LICENSE
├── README.md
├── NAMESPACE
├── man/
├── doc/
├── Meta/
```

### `.gitignore` and `.Rbuildignore`
Files and directories to exclude from Git/GitHub and from R package build.

### `DESCRIPTION`
The `DESCRIPTION` file defines essential metadata and dependencies for your R package. Below are explanations for key fields used in this package:

- **Package**  
  The name of your package. It must match the directory name and be valid as an R object name.

- **Title**  
  A short, plain-English summary of what the package does.

- **Version**  
  The version number of the package.

- **Author / Maintainer**  
  Identifies who created and maintains the package. The maintainer's email is used for bug reports.

- **Description**  
  A longer explanation of the package's purpose.  

- **License**  
  Specifies how the package can be used and redistributed.  

- **Depends**  
  Declares minimum R version required (e.g., `R (>= 4.1.0)`).

- **Imports**  
  Lists packages whose functions are used internally (e.g., `Rcpp`). These packages are loaded when your package loads, but their namespace is not attached.

- **Suggests**  
  Lists optional packages used in vignettes, examples, or tests.  
  E.g., `knitr`, `rmarkdown` are only required to build vignettes.

- **VignetteBuilder**  
  Required when using R Markdown vignettes. Declares the engine used (e.g., `knitr`).

- **LinkingTo**  
  Required when using Rcpp or other C++ packages. Allows access to C++ header files from those packages without loading their namespace.

- **RoxygenNote**  
  Internal version tracker used by `roxygen2`. It is auto-filled by `devtools::document()` and can be ignored by users.

These fields control how your package is interpreted by R.
Make sure they are correctly specified before sharing or submitting your package.

### `LICENSE`
Specifies the terms under which the package can be used, modified, and redistributed.

### `README.md`
This file (you are reading it now). Explains package purpose, structure, setup instructions, and examples.

### `NAMESPACE` (auto-generated)
Automatically created by `devtools::document()` from tags like `@export`, `@importFrom` etc.
Do not edit manually.

### `man/` (auto-generated)
Automatically created by `devtools::document()` from tags like `@export`, `@importFrom` etc.
Do not edit manually.

### `doc/` and `Meta/` (auto-generated)

These folders are automatically generated when building vignettes or installing the package.

- **`doc/`**  
  This folder contains the compiled vignette files, such as `.html`, `.R`, and `.Rmd` copies.  
  It is created when you run `devtools::build_vignettes()` or install the package with `build_vignettes = TRUE`.

  You will typically see files like:
  - `rPracticePkg.html`: the rendered vignette
  - `rPracticePkg.Rmd`: the original source (copied from `vignettes/`)
  - `rPracticePkg.R`: the extracted R code
  
  This folder is included in the installed package so users can access the vignette via:
  ```r
  vignette("rPracticePkg")
  ```

- **`Meta/`**  
  Contains metadata about the installed vignette(s), such as `vignette.rds`.  
  This is used internally by R to register vignette availability and indexing.

## R/ Directory
Contains all R code and documentation.

### `rPracticePkg-package.R`
Provides package-level documentation, seen with `?rPracticePkg` or `help(rPracticePkg)`.

### `init.R`
Declares linkage to the C++ shared library using `@useDynLib`, and imports `sourceCpp()` from `Rcpp` so that C++ functions defined in `src/` can be correctly registered and used.

You can also define an `.onLoad()` function inside this file to specify custom behavior that should run **when the package is loaded**, such as:

- Checking for the presence of required system dependencies
- Registering custom S4 classes
- Setting global options or startup messages (though the latter is discouraged for CRAN packages)

If you don't need any custom initialization, you can omit `.onLoad()`, and the `@useDynLib` directive alone will be sufficient for most Rcpp use cases.

#### `@useDynLib rPracticePkg`

- This tells R to dynamically link the compiled shared library (`.so`, `.dll`) created from your C++ code in the `src/` directory.
- It enables R to call C++ functions (e.g., those marked with `// [[Rcpp::export]]`) from R-level code.
- Required when your package includes native code via `.Call()` or Rcpp.

#### `@importFrom Rcpp sourceCpp`

- This imports the `sourceCpp()` function from the `Rcpp` package into your namespace.
- Allows you to use `sourceCpp()` without prefixing it with `Rcpp::`.
- Mainly used during development when sourcing C++ files manually, but harmless and commonly included.

### `my_functions.R`
Defines exported and internal R functions.
- `multiply_matrix_ten_times()`: Uses Rcpp to multiply matrices and scale result.
- `plus_two_matrix()`: Adds two matrices with NA check.
- `check_for_na()`: Internal function (not exported).

### `example_data.R`
Documents the included dataset `example_data`

## `src/`

This folder contains the C++ source code and compiled artifacts used by the package. It plays a key role when integrating Rcpp-based C++ functions.

- **`example.cpp`**  
  Your own C++ source file, defining functions like `t_cpp()`, `prod_cpp()`, and `t_prod_cpp()`.

- **`Makevars` / `Makevars.win`**  
  Platform-specific makefiles that define compiler flags, optimization settings, and library linking.  
  You can use these to control how the C++ code is built (e.g., enable C++14, link LAPACK/BLAS, set optimization level).

After running `devtools::document()` and building the package, the following files may appear in `src/`:

- **`RcppExports.cpp`**  
  Auto-generated by `Rcpp::compileAttributes()`. This file provides the C interface wrappers that register your C++ functions so they can be called from R using `.Call()`.

- **`RcppExports.o`**, **`example.o`**  
  Compiled object files (from `*.cpp`) produced during package compilation.  
  These are intermediate files used to create the final shared library (`.so`).

- **`rPracticePkg.so`**  
  The shared object (dynamic library) compiled from your C++ files.  
  This is the binary that R links to when calling C++ functions.  
  - On Windows, the extension will be `.dll`
  - On macOS/Linux, it is `.so`

All these files are **automatically managed** and should generally not be edited manually (except for `example.cpp` and `Makevars`).  
You may want to add `.o` and `.so` files to `.gitignore`, since they are machine-specific and recompiled on build.

## data/
Contains `.rda` binary datasets to be used via `data()`.

### `example_data.rda`
Saved using:
```r
example_data <- matrix(c(1, 2, 3, 4), nrow = 2)
save(example_data, file = "data/example_data.rda", version = 2)
```

#### Why `version = 2`?
- R 3.5.0 and above default to `version = 3`, which is **not readable** by older R versions.
- `version = 2` ensures compatibility with R >= 2.4.0.
- Always specify `version = 2` when including `.rda` files for cross-version support.

## vignettes/
Contains long-form documentation and usage examples in R Markdown.

### `rPracticePkg.Rmd`
Includes usage examples, installation instructions, and embedded R code.

### `styles.css`
Optional stylesheet to customize vignette appearance.

## Building the Package

### Step-by-step

```r
install.packages("devtools")
install.packages("roxygen2")

library(devtools)
library(roxygen2)

setwd("/path/to/r_package_practice")

# Step 1:
devtools::document()

# Step 2:
devtools::build_vignettes()
```

After this step, you can push the updated package to GitHub.

### Installing from GitHub (with vignettes)

Once pushed, the package can be installed directly using:

```r
devtools::install_github("downey21/r_package_practice", build_vignettes = TRUE)
```

### Optional: Build a local tar.gz for testing

You can also build a `.tar.gz` package archive locally and install it from source for quick testing:

```r
devtools::build(vignettes = TRUE)           # Create a .tar.gz archive
devtools::install(build_vignettes = TRUE)   # Install locally with vignette support
```

This is useful when you want to test the full build-and-install cycle before pushing to GitHub.

## Notes and Tips

- `man/` and `NAMESPACE` are auto-generated from roxygen comments. Never edit them directly.
- Use `@export` to make a function available to users. Omit it for internal functions.
- Save `.rda` files with `version = 2`.
- Use `@useDynLib` and `@importFrom` in `init.R` to link C++.
- Use `Makevars` and `Makevars.win` for controlling C++ compilation (e.g., CXX14 standard).
- Vignettes must be declared in `DESCRIPTION`:
  ```
  VignetteBuilder: knitr
  Suggests: knitr, rmarkdown
  ```

## Summary

This repository shows a complete and clean example of R package structure, intended for learning and reproducibility.

You now know how to:
- Write R functions and C++ extensions
- Document with roxygen2
- Include internal and exported functions
- Add datasets and vignettes
- Customize build options with Makevars
- Build, install, and share your package
