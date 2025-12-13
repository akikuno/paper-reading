---
title: PyPIへの公開手順 (2025年度版)
published: 2025-12-14
tags: [Python, PyPI, パッケージ公開, GitHub Actions]
category: 技術ドキュメント
draft: false
---

このドキュメントは、PyPIが公式に提供する**Trusted Publishing**を用いて、GitHub Actionsでパッケージを自動公開するための手順をまとめたものです。


# 1. Trusted Publishingとは？

**Trusted Publishing（信頼できる公開）**は、  
PyPIが**OpenID Connect (OIDC)**を用いてGitHub ActionsなどのCIから直接認証する仕組みです。

この方式により、従来必要であった長期有効なAPIトークンをGitHub側に保存する必要がなくなります。

### 🔹従来方式（API Token）
- PyPIでAPI Tokenを発行  
- GitHub Secretsに手動で貼り付け  
- 認証にTokenを使用  
→ 長期トークンなので漏洩リスクがある

### 🔹Trusted Publishing（OIDC）
- GitHub Actionsが短期（15分だけ有効）の**OIDCトークン**を発行  
- PyPIがそのトークンを検証し、短命APIトークンを自動発行  
- Secretsに何も保存しない  
→ **高セキュリティ & 設定が簡単**


# 2. PyPI側の設定

## 2-1. 既存プロジェクトをOIDC（Trusted Publishing）対応にする

1. PyPIにログイン  
   https://pypi.org/account/login/  
2. 対象プロジェクトページへ  
3. 左メニューから  
   **“Publishing → Add a trusted publisher”**を開く  
4. フォームに以下を入力：

- **PyPI Project Name**:  
  `<プロジェクト名>`（例: TSUMUGI）
- **Owner**:  
  `{ユーザー名}`（例: akikuno）
- **Repository name**:  
  `<リポジトリ名>`（例: TSUMUGI-dev）
- **Workflow filename**（任意の名前）:  
  `pypi.yml`
- **Environment**（任意の名前）:  
  `pypi`

5. GitHubにEnvironmentsを登録：

- GitHubリポジトリの**Settings → Environments**へ移動  
- **New environment**をクリックし、上記で指定した名前（例: `pypi`）で環境を作成  
- 任意の権限設定を行う（特に不要ならそのままでOK）


# 3. GitHub Actionsの設定

`.github/workflows/pypi.yml`を作成します。  
GitHubでリリースが公開されたときに自動的にPyPIへアップロードするワークフローの例を以下に示します。  


```yaml
name: Upload Python Package

on:
  release:
    types: [published]

permissions:
  contents: read

jobs:
  release-build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v5

      - uses: actions/setup-python@v5
        with:
          python-version: "3.x"

      - name: Build release distributions
        run: |
          python -m pip install build
          python -m build

      - name: Upload distributions
        uses: actions/upload-artifact@v4
        with:
          name: release-dists
          path: dist/

  pypi-publish:
    runs-on: ubuntu-latest

    needs:
      - release-build

    permissions:
      id-token: write

    environment:
      name: pypi

    steps:
      - name: Retrieve release distributions
        uses: actions/download-artifact@v5
        with:
          name: release-dists
          path: dist/

      - name: Publish release distributions to PyPI
        uses: pypa/gh-action-pypi-publish@release/v1
```

> [!NOTE]
> 最新の情報は以下の公式ドキュメントを参照してください。  
> https://docs.github.com/en/actions/tutorials/build-and-test-code/python#publishing-to-pypi  

> [!WARNING]  
> 上記の公式ドキュメントでは、最終行を  
> ````uses: pypa/gh-action-pypi-publish@6f7e8d9c0b1a2c3d4e5f6a7b8c9d0e1f2a3b4c5d````  
> のようにコミットハッシュを直接指定することで、利用するActionのバージョンを固定しています。  
>  
> しかし、私の環境では  
> *An action could not be found at the URI 'https://api.github.com/repos/pypa/gh-action-pypi-publish/tarball/6f7e8d9c0b1a2c3d4e5f6a7b8c9d0e1f2a3b4c5d' (8411:E059A:105FB4:15F205:692537E5)*  
> というエラーが発生しました（実行ログは[こちら](https://github.com/akikuno/TSUMUGI-dev/actions/runs/19658793263)）。  
>  
> そのため、本ドキュメントでは  
> ````uses: pypa/gh-action-pypi-publish@release/v1````  
> と指定し、常にrelease/v1系列の最新安定版を利用する構成としています。


# 4. リリースして公開する

1. GitHubで新しいReleaseを作成（例: [v0.5.0](https://github.com/akikuno/TSUMUGI-dev/releases/tag/0.5.0)）  
2. Actionsが自動的に起動  
3. PyPIにパッケージがアップロードされる  
4. 反映されるまで10秒待つ  
5. 'https://pypi.org/project/<プロジェクト名>/' で公開を確認  
   例: https://pypi.org/project/TSUMUGI/ 
