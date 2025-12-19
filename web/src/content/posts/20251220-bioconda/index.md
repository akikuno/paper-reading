---
title: Biocondaへのパッケージ登録手順 (2025年版)
published: 2025-12-20
tags: [Python, Bioconda, パッケージ登録]
category: 技術ドキュメント
draft: false
---

# 概要

本ドキュメントは、PyPIに公開済みのパッケージをBiocondaに連携させる手順をまとめています。  

自作パッケージ[TSUMUGI](https://github.com/akikuno/TSUMUGI-dev)をBiocondaに登録した際の具体例を交えながら説明します。


>[!NOTE]
> PyPIへのパッケージ公開手順については、別ドキュメント「[PyPIへのパッケージ公開手順 (2025年版)](https://akikuno.github.io/paper-reading/posts/20251214-pypi/)」を参照してください。

# 前提条件

- GitHubアカウントを持っていること
- PyPIにパッケージが公開されていること

# Biocondaの仕組み

Biocondaでは、パッケージごとに「レシピ」と呼ばれるYAMLファイルをbioconda-recipesリポジトリで管理しています（https://github.com/bioconda/bioconda-recipes）。  
このYAMLファイルを登録することで、Biocondaチャンネルにパッケージが公開されます。  

# 登録の流れ

1. GitHub上でbioconda-recipesをforkします。  
2. forkしたリポジトリをcloneします。  
3. recipes/<パッケージ名>ディレクトリを作り、meta.yamlを配置します。  
4. Pull Requestを作成します。  
5. 自動テスト通過後に`@BiocondaBot please add label`とコメントします。
6. 有志の方が最終チェックし、問題がなければマージされます
7. Biocondaチャンネルにパッケージが公開されます🎊

# 登録手順

## 1. 必要なライブラリのインストール

Biocondaでの作業に必要なCLI（git、gh、grayskull）をconda-forge経由でインストールします。

```bash
conda install -c conda-forge git gh grayskull
```

ghはGitHub CLIツールです。以下のコマンドでログインします。

```bash
gh auth login
```

## 2. bioconda-recipesのforkとclone

以下のコマンドでbioconda-recipesをforkし、必要に応じてcloneまたは同期します。

```bash
# もし既にforkしている場合は、最新状態に同期します
gh repo sync akikuno/bioconda-recipes -b master ||
    gh repo fork bioconda/bioconda-recipes

# もしcloneしていない場合はcloneします
if ! [ -f bioconda-recipes/README.md ] ; then
    git clone https://github.com/akikuno/bioconda-recipes.git

# もしclone済みの場合は、最新状態に同期します
else
    (cd bioconda-recipes && git remote add upstream https://github.com/bioconda/bioconda-recipes.git)
    (cd bioconda-recipes && git switch master && git fetch upstream && git merge upstream/master)
fi
```

>[!NOTE]
> コマンド名の`akikuno`は自分のGitHubユーザー名に置き換えてください。

## 3. grayskullでmeta.yamlを生成

```bash
mkdir -p metayaml
(cd metayaml && grayskull pypi TSUMUGI)
```

上記により、`metayaml/TSUMUGI/meta.yaml`が生成されます。

## 4. meta.yamlの修正

生成されたmeta.yamlに、Biocondaへの登録に必要な以下の2点を追記します。  

- `build`セクションに`run_exports`を追加します。
- `about`セクションに`home`、`dev_url`, `doc_url`を追加します。

:::important
`run_exports`と`home`は記載がないとリントが通らないため必須です。  
`dev_url`, `doc_url`は別のパッケージのレビューで指摘されたため、追記を推奨します。  
:::

>[!NOTE]
> run_exportsは、Biocondaパッケージを他のパッケージが利用するときに許容されるバージョン範囲を示します。  
> 指定すると依存パッケージ側で安全なバージョン範囲が自動的に設定され、互換性の問題を防げます。  
> 例えば`{{ pin_subpackage('tsumugi', max_pin="x.x") }}`なら、0.5.0→0.5.1のようなマイナーバージョン更新は許容されますが、0.5.0→0.6.0のようなメジャーバージョン更新は許容されません。  
> 安定版(1.0.0)前はマイナーバージョンで破壊的変更が入る可能性が高いため、`max_pin="x.x"`を推奨します。  


[最終的なmeta.yaml](https://github.com/bioconda/bioconda-recipes/pull/60893/files)は、以下のとおりです：

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

## 5. meta.yamlの配置

生成したmeta.yamlを、bioconda-recipesの`recipes/tsumugi/meta.yaml`として配置します。

```bash
mkdir -p bioconda-recipes/recipes/tsumugi
cp metayaml/TSUMUGI/meta.yaml bioconda-recipes/recipes/tsumugi/meta.yaml
```

## 6. Pull Requestの作成

作成したmeta.yamlをコミットします。  

仮にブランチ名を`add-tsumugi-0.5.0`とした場合、以下のコマンドを実行します。

```bash
git checkout -b add-tsumugi-0.5.0
git add recipes/tsumugi/meta.yaml
git commit -m "Add TSUMUGI version 0.5.0"
git push origin add-tsumugi-0.5.0
```

以下のURLにアクセスし、Pull Requestを作成します。

https://github.com/<ユーザー名>/bioconda-recipes/pull/new/<ブランチ名>

これでbioconda-recipesリポジトリに対してPull Requestが作成されます。


## 7. 自動テストとメンション

Pull Requestを作成すると、自動テストが走ります。
自動テストが通過したら、コメント欄に

`@BiocondaBot please add label`

とメンションします。

:::important
`@BiocondaBot please add label`を忘れると永遠にレビューしてくれません（数敗）。  
必ずコメントしてください。
:::


## 8. マージと公開

有志の方が最終チェックし、問題がなければマージされます。  

:::important
この最終チェックはボランティアの方が行っているため、チェックまでに数日がかかる場合があります。  
感謝の気持ちでお待ちください🙏
:::

マージされると、数分でBiocondaにパッケージが公開されます。


>[!NOTE]
> 以降のバージョン更新はPyPIの更新に自動で追従します。
