# PS-Tools

> A collection of PowerShell tools and helper functions for scripting

## Overview

**PS-Tools** is an expanding library of reusable PowerShell functions designed to make scripting easier, cleaner, and more maintable.
It includes small utilities (like `Write-File` and `Test-StringLike`) as well as more complex helpers (such as `Test-ValidPath`).
This library is mainly intended for my personal use but is published under the MIT License for others to use if they so desire.

---

## Installation

### Option 1: Install from PowerShell Gallery
*(Coming soon once published)*

```powershell
Install-Module -Name KadragonTech.PS-Tools -Scope CurrentUsers
```

### Options 2: Install directly from source

```powershell
git clone https://github.com/KadragonTech/PS-Tools.git
Import-Module "$PWD\PS-Tools\PS-Tools.psm1"
```

## Usage

### Once imported you can use the functions directly:

```powershell
Test-StringLike -Value "Hello Github" -NotEmpty
Test-ValidPath "C:\Github\file.git" -PathType File
```

### List all included functions:

```powershell
Get-Command -Module KadragonTech.PS-Tools
```

## Contributing
Contributions, feature requests, and issues are welcome!
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

This project is licensed under the [MIT License](LICENSE).