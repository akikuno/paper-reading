# 論文情報
**PhenoDigm: analyzing curated annotations to associate animal models with human diseases**  
Damian Smedley, Anika Oellrich, Sebastian Köhler, et al.  
*Database*, 2013, https://doi.org/10.1093/database/bat025  
Copyright: [CC BY-NC 3](https://creativecommons.org/licenses/by-nc/3.0/)

---

# 背景と目的

モデル動物はヒト疾患研究において不可欠な役割を果たしており、特にノックアウトマウスやゼブラフィッシュ変異体などの表現型データは、遺伝子機能の理解や疾患モデルの確立に広く活用されている。  
しかし、ヒトとモデル動物では用いられる表現型用語や記述体系が異なるため、両者の比較や自動的な対応付けが困難であった。  

当時（2010年代初頭）の主な課題としては以下の点が挙げられる。  
- **表現型オントロジーの断片化**：ヒト（HPO）、マウス（MP）、ゼブラフィッシュ（ZP）などが別々に構築され、直接比較できる共通の枠組みが存在しなかった。  
- **表現型類似度の定量化手法の整備不足**：表現型の一致度を定量化する統一的なアルゴリズムが整備されておらず、異種オントロジー間での比較が曖昧だった。  

これらの問題を解決するために、著者らは異種オントロジー間の論理定義と語彙マッピングを統合し、  
**ヒト疾患表現型（HPO）とモデル動物表現型（MP, ZP）を直接比較可能にする計算基盤**を構築した。  
その上で、表現型類似度を定量的に評価し、疾患とモデル間の関連を自動推定する手法 **PhenoDigm** を開発した。  

> [!NOTE]
> HPO （Human Phenotype Ontology）：ヒト表現型を体系的に記述したオントロジー  
> - https://hpo.jax.org/app/  
> 
> MP （Mammalian Phenotype Ontology）：マウス表現型を記述したオントロジー  
> - https://www.informatics.jax.org/vocab/mp_ontology  
> 
> ZP （Zebrafish Phenotype Ontology）：ゼブラフィッシュ表現型を記述したオントロジー  
> - https://github.com/obophenotype/zebrafish-phenotype-ontology


>[!NOTE]
> 論理定義：オントロジー概念を他の概念や属性で形式的に定義すること。  
> - 表現型の文脈では、各表現型を、「器官」と「性質」に分割したもの
> - 例："MP:0000266: abnormal heart morphology" は "heart"（器官）と "abnormal morphology"（性質）で定義されるので、論理定義では`has_part some (Heart and has_quality some Abnormal_morphology)` と表現される。  

>[!NOTE]
> 語彙マッピング：異なるオントロジー間で同義語や関連語を対応付けること。  
> - 例："HP:0000347: Micrognathia" と "MP:0004592: small mandible" は表現は異なるが、どちらも「下顎（mandible）」という器官（UBERON:0001684）に「小さい（PATO:0000587）」という性質が付与された状態を意味する。  
> そのため、両者の論理定義に共通して現れる UBERON（器官） と PATO（性質） の組み合わせを手がかりに、「同じ生物学的概念を指している」と表現することができる。  

---

# 主要な実験手法と解析

## データ統合

ヒト疾患表現型に関してOMIM （HPO注釈付き）、マウス表現型に関してMGD （MP注釈付き）、Sanger-MGP（MP注釈付き）、ゼブラフィッシュ表現型に関してZFIN（ZP注釈付き）から表現型とそれに関わる遺伝子を収集し、論理定義と語彙マッピングでオントロジーを統合（UBERON、Neuro-Behaviour Ontology、Phenotypic Quality Ontologyを包含）した。各リソースの件数や注釈数の分布を整理し、評価用にMorbidMap （OMNI由来の遺伝子ー疾患対応表）およびMGDの文献（マウスモデル由来の遺伝子ー疾患対応表）を用いた。

## 三段階スコアリング（図1）

1. **異種オントロジーの統合と各タームの類似度計算**：統合したオントロジー表現を用いて、、**Jaccard指数** と **Information Content（IC）** を算出。両者の幾何平均を各タームごとの類似度スコアとする  
2. **ヒト疾患とモデル動物の類似度比較**：ヒト疾患とモデル動物のオントロジータームの集合間で、各タームごとの**最大類似度スコア**を集約し、最大値（maxScore）と平均（avgScore）を求める  
3. **0-100の値にスケーリング**：当該疾患に対する**仮想的最適モデル**（各HPO項目に対し最も高得点のモデル側項目を選ぶ）に対する百分率（maxPercentage / avgPercentage）に規格化し、その平均を **combinedPercentageScore** として用いる  

![bat025f1p](https://github.com/user-attachments/assets/b7edfb54-cb67-4b14-aff6-b9e91a6fd867)

---

# 主要な結果と考察

## 再現性能（図2）

- PhenoDigmスコアを用いた**疾患–モデル対応推定の精度評価**を示している

- 表現型情報だけで、疾患が当てられるかどうかを評価

- Fig2A: MGD文献モデルに登録されている「マウス遺伝子ー疾患」関係を正解とするROC曲線を描画
  - PhenoDigmスコアが高い順に正しい疾患（MGDで文献的に対応している疾患）が上位に来るかを評価
  - 旧手法（MouseFinder）の複数の類似度指標（maxIC, avgIC, maxSimJ, avgSimJ）と比較
  - MGD-combined score（PhenoDigmスコア）がAUC 0.92で既報を上回る性能 （既報も0.90などなので、わりと微差かも…）

- Fig2B: OMIM MorbidMapに登録されている「ヒト遺伝子ー疾患」関係を正解とするROC曲線を描画
  - マウスおよびゼブラフィッシュのヒトオルソログ遺伝子について、PhenoDigmスコアを算出し、類似度の高い順に疾患をランキング。
  - 「既知のOMIM疾患が上位にランクされるか」をもとに ROC 曲線を作成。
  - 結果はマウス：AUC 0.86、ゼブラフィッシュ：AUC 0.58
    - 少なくともマウスは非常に高い性能を示し、ヒト疾患との関連を一定程度捉えていることが示された

![bat025f2p](https://github.com/user-attachments/assets/5d8f669d-9711-484c-a896-6e31b8875086)

---

# 新規性・意義

- 表現型オントロジー横断の**論理定義＋語彙マッピング**により、異種オントロジー（HPO–MP–ZP）を一体化したうえで、**タームペアの類似度の定量化→ タームの集合間の類似度定量化** で表現型類似度を定量化したPhenoDigm手法を提案した点  
- 既報（MouseFinder, PhenomeNET）と比較して、**0-100で類似度スコアがスケールされている**ことにより、「その疾患に対して**どれだけ良い一致か**」を直感的に評価できる点  

---

# 限界と今後の展望

- ゼブラフィッシュでの性能低下（AUC 0.58）は、オントロジーの注釈方式（EQ→ZP化）の違いや進化距離の影響が示唆され、さらなる最適化が必要  

>[!NOTE]
> 2025年現在では、ZP（Zebrafish Phenotype Ontology）は HPO や MP と同様に OBO / OWL 形式で整備されており、  
> 注釈方式やファイル構造の差異はほとんど見られない。  
> https://obofoundry.org/ontology/zp.html  
> 
> 一方、PhenoDigm 論文が発表された 2013 年当時は、ZFIN では主に **EQ モデル（Entity–Quality モデル）** によって表現型が記述されており、形式が異なっていたようである。  
> そのため、HPO / MP との自動対応付けが難しく、AUC が低下した（0.58）一因との議論あり。  

---

# 読後の感想

- **人類の知（この論文ではオントロジー）を最大限に活用して新しいアルゴリズムを提唱した論文**
  - このような膨大な情報から宝を探し出す知能駆動型研究、憧れます😻

- この論文の肝は**論理定義と語彙マッピングによって異種オントロジーの各タームの類似度を定量化したこと**、と**異なるオントロジータームの集合における類似度評価指標を確立したこと**の2つかと。
  - 異種オントロジーをひとつのOWLファイルにまとめて、類似度計算を行うという発想は、いづれヒトとの比較のときに取り入れたい。
  - 概念は理解できるが、まだ実装レベルでは理解が追いついていない…

- オントロジータームの集合における類似度評価指標は、TSUMUGIにも活用した
  - https://github.com/akikuno/TSUMUGI-dev/blob/60e2c3b84a25d5e545b4443a6ba67d99c5201af9/src/TSUMUGI/similarity_calculator.py#L335
  - Fig1のStep2,3を読み解いて実装する作業はとても勉強になった

