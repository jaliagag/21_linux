# percipio course

<https://dxc.percipio.com/channels/99520c21-1a26-11e7-aa4b-c7a8e598b690>

- windows: ver path **echo $env:Path**
- call mod extension: `go mod init example.local/demo`
- to call a mod on github: `go get github.com/...`
- stuff downloaded from github are on `/usr/go/pkg/mod/gihub.com/....`

formal grammar: EBNF

1. package declaration
2. import packages
3. functions
4. variables
5. statements and expressions
6. comments

- gofmt --> automatic formatting
- semicolons terminate statements - they don't appear in the code

```go
// this is WRONG
if i < foo()
{
    bar()
}
// go considers that there is a semicolon after foo ();
// the right way
if i < foo() {
    bar()
}
```

functioncan return multiple values - blank identifier --> `_`

```go
// irrelevant value
if val, err := os.Stat(path); os.IsNotExist(err) {
    fmt.Pringtf("%s does not exist\n", path)
}
// only the error is important
// use blank identifier instead - to descard the unused variable
if _, err := os.Stat(path); os.IsNotExist(err) {
    fmt.Pringtf("%s does not exist\n", path)
}
// if the variable is not used in the program, it can cause an error
```

## Data types

- primitives
  - integers - no decimals; platform dependent (the size of each depends on the architecture they were compiled for)
    - unsigned integers - uint: 0 to infinite; sizes uint8 16 32 64; **byte - uint8**
    - int: negative numbers; sizes int8 16 32 64; **rune = int32** --> used to represent unicode types
    - uintpr
    - floating points - decimal componentes - float
    - complex number type - float + imaginary components
    - booleans: either true or false; _bool_
    - operators
      - && and
      - || or
      - ! not
    - string: sequence of bytes - never negative; strings are immutable
- complex (arrays, maps)

## Declaring variables

```go
package main

import {
    "fmt"
}

func main() {
    msg := "holanda"
    x := 1
    fmg.Println(msg)
    fmg.Println(x)
}
```

constants

```go
package main

import {
    "fmt"
    //"math"
}

func main() {
    //fmg.Println(math.Pi)
    const pi = 3.14
    fmt.Println(pi)
    fmt.Prinff("type: %T, value: %v") // prinf - gie format to the ouput
}
```
