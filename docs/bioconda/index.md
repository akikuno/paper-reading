# Biocondaへのパッケージ登録手順 (2025年版)

## 概要

このドキュメントでは、Python パッケージを Bioconda に登録するための手順を説明します。  
本手順は、PyPI に公開済みのパッケージを Bioconda に連携させる一般的な方法に基づいています。

## 前提条件

- パッケージが PyPI に公開されていること  
- PyPI のソースから pip install が正常に動作すること  
- GitHub Actions などで PyPI への自動リリースが整備されていること  
- Anaconda アカウントがあること（必須ではありませんが便利です）

## Bioconda の仕組み

Bioconda では、パッケージごとに「レシピ」を bioconda-recipes リポジトリで管理します。  
コード本体のリポジトリとは独立しています。

bioconda-recipes:  
https://github.com/bioconda/bioconda-recipes

## 基本的な登録フロー

1. GitHub 上で bioconda-recipes を fork します。  
2. fork したリポジトリを clone します。  
3. recipes/<パッケージ名> ディレクトリを作り、meta.yaml を配置します。  
4. Pull Request を作成します。  
5. CI が通過すると自動マージされ、Bioconda に公開されます。

## ステップ・バイ・ステップ

### 1. ghとgrayskullのインストール

### 2. gh auth login

### 3. bioconda-recipesのforkとclone

```bash
gh repo fork bioconda/bioconda-recipes --clone=true
cd bioconda-recipes
```

### 4. grayskullでmeta.yamlを生成

```bash

```

### 5. meta.yamlの修正

生成されたmeta.yamlに、さらにBioCondaへの登録に必要な以下の2点を追加します：  

- `build` セクションに `run_exports` を追加します。
- `about` セクションに`home`、`dev_url`, `doc_url`を追加します。


[最終的に作られたmeta.yaml](https://github.com/bioconda/bioconda-recipes/pull/60893/files)は以下のとおりです：

```yaml

{% set name = "TSUMUGI" %}
{% set version = "0.5.0" %}

package:
  name: {{ name|lower }}
  version: {{ version }}

source:
  url: https://pypi.org/packages/source/{{ name[0] }}/{{ name }}/tsumugi-{{ version }}.tar.gz
  sha256: b3b3a8e0acb8a0f4326e45aabb10d7d3b9e0f0cd432ef0cc49f3d61aeae04350

build:
  entry_points:
    - tsumugi = TSUMUGI.main:main
  noarch: python
  script: {{ PYTHON }} -m pip install . -vv --no-deps --no-build-isolation
  number: 0
  run_exports:
    - {{ pin_subpackage('tsumugi', max_pin="x.x") }}

requirements:
  host:
    - python >=3.10
    - poetry-core
    - pip
  run:
    - python >=3.10
    - numpy >=1.21.0
    - tqdm >=4.64.0
    - networkx >=3.3

test:
  imports:
    - TSUMUGI
  commands:
    - pip check
    - tsumugi --help
  requires:
    - pip

about:
  summary: 'TSUMUGI: Phenotype-driven gene network identifier'
  license: MIT
  license_file: LICENSE
  home: "https://github.com/akikuno/tsumugi"
  dev_url: "https://github.com/akikuno/tsumugi"
  doc_url: "https://github.com/akikuno/tsumugi/blob/{{ version }}/README.md"


extra:
  recipe-maintainers:
    - akikuno

```

### 6. Pull Request の作成

```bash
git checkout -b add-tsumugi-0.5.0
git add recipes/tsumugi/meta.yaml
git commit -m "Add TSUMUGI version 0.5.0"
git push origin add-tsumugi-0.5.0
```


### 7. bioconda-recipes リポジトリで Pull Request を作成


### 8. CI の確認とマージ

`@BiocondaBot please add label`


