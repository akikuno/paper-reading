## 論文情報

**Construction and evaluation of a new rat reference genome assembly, GRCr8, from long reads and long-range scaffolding**  
Kai Li, Melissa L. Smith, J. Chris Blazier, et al.  
*Genome Research*, 2024, Vol. 34: 2081–2093  
https://doi.org/10.1101/gr.279292.124  
Copyright: CC BY-NC 4.0

---

## 背景と目的

Rattus norvegicus（実験用ラット）は、行動・生理・薬理など多様な研究で重要なモデル動物である。  
ラットの参照ゲノムはBN/NHsdMcwiを基に更新が続けられており、既存の参照ゲノム**mRatBN7.2**（2020）は、PacBio CLRを中心に構築されていたが、

- 反復配列（rDNA, centromere, Y染色体など）の欠落  
- CLRの高エラー率により発生した偽SNP  
- 近交系BNラットを偽二倍体として処理したことによる誤ったハプロタイプ分離  

といった問題が残っていた。

> [!NOTE]
> BN/NHsdMcwi  
> Brown Norway（BN）系統の一つで、実験用ラットとして広く利用されている近交系。  
> Brown Norway系統（BN）をHarlan Sprague Dawley（Hsd）が取り扱い、ウィスコンシン医科大学（Mcwi）で維持されているサブコロニー。
> [過排卵処理(PMSG・hCG投与)しても1匹当たり平均して2.2個しか排卵しない](https://pmc.ncbi.nlm.nih.gov/articles/PMC5081740/)ので、生殖工学技術に対する適応に難がある。


> [!NOTE]
> 偽二倍体（pseudo-diploid）  
> 近交系などで実質的に同一配列であるにもかかわらず、二倍体としてアセンブリされてしまう現象。PacBio CLRの高エラー率のために、非常に似た重複領域（segmental duplication）が、誤って“異なるアレル”とみなされたことによって、一方のコピーは “primary assembly（主ハプロタイプ）”、もう一方は “alternate assembly（代替ハプロタイプ）” として分離されてしまう。その結果、**片方が主配列から落とされる（喪失する）**という事態が発生した。


そこで著者らは**PacBio HiFi（高精度長鎖リード）＋ 光学マッピング(Bionano)＋ Hi-C (Arima)**を組み合わせて、  
精度・完全性・構造連続性を大幅に向上させた新しい参照ゲノム**GRCr8**を構築した。


> [!NOTE]
> ENSEMBLEでは[release-114](https://ftp.ensembl.org/pub/release-114/fasta/rattus_norvegicus/dna/)からGRCr8が利用可能。
> UCSC Genome BrowserおよびGGGenomeでは、2025/11/29現在は未対応。

## 結果

### アセンブリ

![alt text](images/rat-genome/fig1.png)

Fig.1に示すパイプラインを用い、

1. **HiCanuによるHiFi de novo assembly**  
2. 光学マップ（Bionano）によるハイブリッドスキャフォールディング  
3. **Hi-C（SALSA2）による長距離構造補正**  
4. mRatBN7.2をテンプレートとした**RagTagによる染色体組み立て**  
5. PacBio CLRでgap filling  
6. Illumina（Pilon）によるpolishing

> [!NOTE]
> BUSCO: Benchmarking Universal Single-Copy Orthologs
> 哺乳類なら必ず1コピーあるはずの“保存遺伝子セット”の網羅率を測る指標.

> [!NOTE]
> Merqury QV  
> アセンブリの塩基精度をk-merベースで評価する指標。
> QV: 品質値（Quality Value）であり、数値が高いほどエラー率が低い。
> ```math
> QV = -10 \times \log_{10}\!\left( \mathrm{error\_rate} \right)
>```
> 上の定義式から、エラー率は以下のように求められる。
> ```math
> \mathrm{error\_rate}
>   = 10^{-\,QV/10}
> ```
> よって、GRCr8のQV=59.5からエラー率を計算すると、
> ```math
> \mathrm{error\_rate}
>   \approx 10^{-\frac{59.5}{10}}
>   = 10^{-5.95}
>   \approx 1.1 \times 10^{-6}
> ```
> つまり、**1 Mbあたり約1.1箇所の塩基エラー**に相当する。


**主なアセンブリ指標：**

- **総サイズ2.8496 Gb（98.7% が染色体配置）**  
- **Scaffold N50 = 137 Mb（染色体スケール）**  
- Merqury解析で**QV=59.5（誤り率 ≈ 1.1×10⁻⁶）**  
- BUSCO（Glires）**99.7% 完全**

k-mer解析（Fig.2）では、BN/NHsdMcwiが**高度に近交化した「実質1倍体系統」**であることが確認され、  
mRatBN7.2の“偽ハプロタイプ分離”が不要だったことが明確となった。


![alt text](images/rat-genome/fig2.png)


## Identification of new components of the assembly  


GRCr8は反復領域を明らかにし、特に：

- **Chr3 / 11 / 12のrDNAクラスター領域**  
- **Chr19の巨大重複領域（>15 Mb）**  
- **ChrYのヘテロクロマチン（18 Mb → 59 Mbに増加）**

が大きく改善された（Table 3, Fig.4）。

### セントロメア領域（Fig.3）
StainedGlassにより、以下を含む**0.5〜5 Mbの強い自己相同性ブロック**が検出された：

- メタセントリック染色体（13,14,15,16,17,18,19,20）  
- 一部のアクロセントリック・テロセントリック染色体

### テロメア領域（Table 2）
TTAGGG反復が多数の染色体でmRatBN7.2より大幅に延長して検出され、  
**telomere-to-telomereに近い構造的完成度**を達成している。

---

## The pseudoautosomal regions of the sex chromosomes  


ヒトではX-Yに多数のPAR遺伝子が存在するが、ネズミ科では大部分が消失している。  
本研究では、ヒトPARの16遺伝子のラットにおける位置を調査（Table 5）。  

結果：

- **12遺伝子：常染色体に再配置**  
- **4遺伝子：完全消失**  
- **X-Y間の真正のPARは存在せず**

→ ラットは**PARがほぼ完全に退化した哺乳類**であり、  
X-Y間組換えは限定的である可能性が高い。

> [!NOTE]
> マウスとラットで存在する遺伝子とそうでない遺伝子の組み合わせが異なるのは興味深いです。

---

## Gene annotation（遺伝子アノテーション）


### 新規遺伝子

NCBI RefSeqにより10 billionのショートリードと 35 millionのロングリードを利用し、**約80%のタンパク質コード遺伝子にキュレート済みRefSeq転写産物（NM_）**が割り当てられた。


特にChr19では、Iso-Seq（Fig.5）で精巣特異的な**Speer類似遺伝子群**の多数の発現が確認され、  
性染色体ドライブ関連領域の大幅な拡張が示唆された。

GRCr8はNCBI RefSeqによりアノテーションされ、

- **780個の “unmapped gene”**（mRatBN7.2では位置不明）  
- **373個の “novel gene”**（既存領域にあったが未注釈）

合計**1,100以上の新規タンパク質コード遺伝子**が注釈された。


---

## Base-level assembly accuracy（塩基精度）

Merqury QV=59.5に加え、  
多系統の近交系ラット42系統で共有される“偽変異”の解析により：

- mRatBN7.2：**129,000の偽SNPが全系統で共有**  
→ CLRのエラーが主因  
- GRCr8：**わずか550**  

→ **誤った変異がほぼ除去された参照ゲノム**になった。

---

# Discussion

GRCr8は以下の点でmRatBN7.2を本質的に上回る：

- **正しい1倍体系統として構築された最初のラット参照ゲノム**  
- 反復領域（rDNA, centromere, telomere, Y染色体）の大幅回収  
- セクシャルドライブ関連の多コピー遺伝子群の検出  
- 塩基精度（QV59.5）と構造精度（N50=137 Mb）の両立  
- 大規模欠落が消失し、“偽変異”が激減

著者らは、今後ONT ultra-longなどによるT2T（telomere-to-telomere）化や、  
他の近交系（SHR, F344）の高精度ゲノム整備によって、  
ラット遺伝学・生殖生物学・行動研究がさらに発展すると述べている。


---

## 主要な実験手法と解析

![alt text](images/rat-genome/fig1.png)

### データ生成
- **PacBio HiFi（40×）**：BN/NHsdMcwi ♂ の高精度長鎖リード  
- **PacBio CLR（既存データ）**：ギャップフィリングに利用  
- **Bionano光学マップ**：長距離スキャフォールディング  
- **Hi-C（Arima）**：染色体レベルの構造補正  
- **Illumina短鎖（50×）**：最終polishing  
- **Iso-Seq（多組織）**：遺伝子構造・新規遺伝子群の検証

### 組み立て（Fig.1）

1. **HiCanu**によるHiFiベースde novoアセンブリ  
2. 光学マップと統合しハイブリッドスキャフォールディング  
3. **SALSA2**によるHi-Cベースの再スキャフォールディング  
4. **RagTag**を用いた染色体レベルの構築（mRatBN7.2をテンプレート）  
5. **CLR contig**によるギャップフィリング  
6. **Pilon + Illumina**による塩基精度の修正  
7. **Sanger Rapid Curation（Hi-C heatmap）**による最終手動キュレーション

---

## 主要な結果と考察

### 1. アセンブリ品質の大幅改善


### 2. 染色体配列の大幅な増加（Table 3）

特に増加が顕著だったのは：

- **Chr Y：+226%（18→59 Mb）**  
- **Chr 19：+29%（+16.9 Mb）**  
- **Chr 3, 11, 12：rDNA（NOR）領域の大規模拡張**  

いずれもmRatBN7.2では欠落していた反復配列・ヘテロクロマチン領域である。

### 3. セントロメア・テロメアの解析（Table 1, 2 / Fig.3）

StainedGlass（Fig.3）を用いた自己相同性解析により：

- **多くの染色体で0.5–5 Mbのセントロメア反復配列が新たに出現**
- テロメア六量体（TTAGGG）も多数の染色体で**長大化**して検出（特にメタセントリック染色体）

→ 以前のラット参照では欠落していた高反復領域の大規模回収に成功。

### 4. 新規遺伝子の追加（NCBI RefSeq Annotation）

- **1,100以上の新規タンパク質コード遺伝子が追加**  
- そのうち：
  - **780：以前は未配置（unmapped）でmRatBN7.2では位置不明**  
  - **373：既存領域にあったが未注釈（novel）**

特にChr19には**Speer関連遺伝子（精巣特異的）**が多数クラスター化（Fig.5）。  
Iso-Seqでも豊富に発現が確認され、**性染色体ドライブに伴う反復拡張**が示唆された。

### 5. PAR（擬似常染色体領域）の再検討（Table 5）

- ヒトではX-Yに多数のPAR遺伝子が存在  
- マウスではわずか2遺伝子  
- **ラット（GRCr8）ではPAR遺伝子はさらに消失／転座**  
  - 16遺伝子のうち**12が常染色体へ、4は完全消失**
- ラットは**PAR機能がほぼ欠損した哺乳類**であり、  
  X-Y間組換えはほぼ行われない可能性が高い。

### 6. 構造変異解析（Table 4）

mRatBN7.2との比較で、

- 大規模な“未整合領域（not aligned）”が160 Mb  
- 多数の“segmental duplication / inversion / translocation”が修正  
- Y染色体の遠位領域（ヘテロクロマチン）はGRCr8で初めて大規模に出現（Fig.4）

---

## 限界と今後の展望

**限界**

- Telomere-to-telomere（T2T）には未到達  
- 特にrDNAクラスター・巨大衛星配列はHiFiでも完全解決は困難  
- 一部のギャップはCLRで埋めており、完全精度ではない可能性

**今後の展望**

- Nanoporeシークエンスなどより長いリードを組み合わせたT2Tアセンブリ  
- 近交系ラット（SHR、F344など）の高精度ゲノム整備  
- Speerクラスターなど**性染色体ドライブ関連領域**の機能解析  
- RGDによるアノテーション強化

---

## 読後の感想


なお、 Markdownで数式を書くのには`$$ ... $$`か、````math ... ````の中にLaTeX記法で書くのがあるかと思いますが、個人的には````math ... ````で書くのが楽に感じました。  
