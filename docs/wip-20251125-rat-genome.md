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
> Brown Norway 系統（BN）をHarlan Sprague Dawley（Hsd）が取り扱い、ウィスコンシン医科大学（Mcwi）で維持されているサブコロニー。
> [過排卵処理(PMSG・hCG投与)しても1匹当たり平均して2.2個しか排卵しない](https://pmc.ncbi.nlm.nih.gov/articles/PMC5081740/)ので、生殖工学技術に対する適応に難がある。


> [!NOTE]
> 偽二倍体（pseudo-diploid）  
> 近交系などで実質的に同一配列であるにもかかわらず、二倍体としてアセンブリされてしまう現象。PacBio CLR の高エラー率のために、非常に似た重複領域（segmental duplication）が、誤って“異なるアレル”とみなされたことによって、一方のコピーは “primary assembly（主ハプロタイプ）”、もう一方は “alternate assembly（代替ハプロタイプ）” として分離されてしまう。その結果、**片方が主配列から落とされる（喪失する）**という事態が発生した。


そこで著者らは**PacBio HiFi（高精度長鎖リード）＋ 光学マッピング (Bionano)＋ Hi-C (Arima)** を組み合わせて、  
精度・完全性・構造連続性を大幅に向上させた新しい参照ゲノム**GRCr8** を構築した。


## 結果

### アセンブリ

![alt text](images/rat-genome/fig1.png)

Fig.1 に示すパイプラインを用い、

1. **HiCanu による HiFi de novo assembly**  
2. 光学マップ（Bionano）によるハイブリッドスキャフォールディング  
3. **Hi-C（SALSA2）による長距離構造補正**  
4. mRatBN7.2 をテンプレートとした **RagTag による染色体組み立て**  
5. PacBio CLR で gap filling  
6. Illumina（Pilon）による polishing

> [!NOTE]
> BUSCO: Benchmarking Universal Single-Copy Orthologs
> 哺乳類なら必ず1コピーあるはずの“保存遺伝子セット”の網羅率を測る指標.

> [!NOTE]
> Merqury QV  
> アセンブリの塩基精度を k-mer ベースで評価する指標。
> QV: 品質値（Quality Value）であり、数値が高いほどエラー率が低い。
> ```math
> QV = -10 \times \log_{10}\!\left( \mathrm{error\_rate} \right)
>```
> 上の定義式から、エラー率は以下のように求められる。
> ```math
> \mathrm{error\_rate}
>   = 10^{-\,QV/10}
> ```
> よって、GRCr8 の QV=59.5 からエラー率を計算すると、
> ```math
> \mathrm{error\_rate}
>   \approx 10^{-\frac{59.5}{10}}
>   = 10^{-5.95}
>   \approx 1.1 \times 10^{-6}
> ```
> すなわち、**1 Mb あたり約1.1箇所の塩基エラー**に相当する。



**主なアセンブリ指標：**

- **総サイズ 2.8496 Gb（98.7% が染色体配置）**  
- **Scaffold N50 = 137 Mb（染色体スケール）**  
- Merqury 解析で **QV=59.5（誤り率 ≈ 1.1×10⁻⁶）**  
- BUSCO（Glires）**99.7% 完全**

k-mer 解析（Fig.2）では、BN/NHsdMcwi が**高度に近交化した「実質1倍体系統」**であることが確認され、  
mRatBN7.2 の“偽ハプロタイプ分離”が不要だったことが明確となった。


![alt text](images/rat-genome/fig2.png)


## Identification of new components of the assembly  
（新しく取り込まれた領域）

GRCr8 は反復性の高い領域を多数回収しており、特に：

- **Chr3 / 11 / 12 の rDNA クラスター領域**  
- **Chr19 の巨大重複領域（>15 Mb）**  
- **ChrY のヘテロクロマチン（18 Mb → 59 Mb に増加）**

が大きく改善された（Table 3, Fig.4）。

### セントロメア領域（Fig.3）
StainedGlass により、以下を含む**0.5〜5 Mb の強い自己相同性ブロック**が検出された：

- メタセントリック染色体（13,14,15,16,17,18,19,20）  
- 一部のアクロセントリック・テロセントリック染色体

### テロメア領域（Table 2）
TTAGGG 反復が多数の染色体で mRatBN7.2 より大幅に延長して検出され、  
**telomere-to-telomere に近い構造的完成度**を達成している。

### 新規遺伝子
NCBI RefSeq により：

- **780 個の “unmapped gene”**（mRatBN7.2 では位置不明）  
- **373 個の “novel gene”**（既存領域にあったが未注釈）

合計 **1,100 以上の新規タンパク質コード遺伝子**が注釈された。

特に Chr19 では、Iso-Seq（Fig.5）で精巣特異的な **Speer 類似遺伝子群**の多数の発現が確認され、  
性染色体ドライブ関連領域の大幅な拡張が示唆された。

---

## The pseudoautosomal regions of the sex chromosomes  
（性染色体 PAR の解析）

ヒトでは X-Y に多数の PAR 遺伝子が存在するが、マウスでは大部分が消失している。  
本研究では、ヒト PAR の 16 遺伝子のラットにおける位置を調査（Table 5）。

結果：

- **12 遺伝子：常染色体に再配置**  
- **4 遺伝子：完全消失**  
- **X-Y 間の真正の PAR は存在せず**

→ ラットは **PAR がほぼ完全に退化した哺乳類**であり、  
X-Y 間組換えは限定的である可能性が高い。

---

## Gene annotation（遺伝子アノテーション）

GRCr8 は NCBI RefSeq によりアノテーションされ、

- mRNA：85,576  
- コーディング遺伝子：23,154  
- noncoding RNA：30,129  
- pseudogene：8,687  

など、**mRatBN7.2 より包括的かつ整合的な遺伝子セット**が得られた（Table 6）。

Liftoff による比較では、mRatBN7.2 の遺伝子の大部分が GRCr8 に移植可能であり、  
構造的欠落がほぼないことが確認された。

---

## Base-level assembly accuracy（塩基精度）

Merqury QV=59.5 に加え、  
多系統の近交系ラット42系統で共有される“偽変異”の解析により：

- mRatBN7.2：**129,000 の偽 SNP が全系統で共有**  
→ CLR のエラーが主因  
- GRCr8：**わずか 550**  

→ **誤った変異がほぼ除去された参照ゲノム**になった。

---

# Discussion（考察）

GRCr8 は以下の点で mRatBN7.2 を本質的に上回る：

- **正しい 1 倍体系統として構築された最初のラット参照ゲノム**  
- 反復領域（rDNA, centromere, telomere, Y染色体）の大幅回収  
- セクシャルドライブ関連の多コピー遺伝子群の検出  
- 塩基精度（QV59.5）と構造精度（N50=137 Mb）の両立  
- 大規模欠落が消失し、“偽変異”が激減

著者らは、今後 ONT ultra-long などによる T2T（telomere-to-telomere）化や、  
他の近交系（SHR, F344）の高精度ゲノム整備によって、  
ラット遺伝学・生殖生物学・行動研究がさらに発展すると述べている。


---

## 主要な実験手法と解析

![alt text](images/rat-genome/fig1.png)

### データ生成
- **PacBio HiFi（40×）**：BN/NHsdMcwi ♂ の高精度長鎖リード  
- **PacBio CLR（既存データ）**：ギャップフィリングに利用  
- **Bionano 光学マップ**：長距離スキャフォールディング  
- **Hi-C（Arima）**：染色体レベルの構造補正  
- **Illumina 短鎖（50×）**：最終 polishing  
- **Iso-Seq（多組織）**：遺伝子構造・新規遺伝子群の検証

### 組み立て（Fig.1）

1. **HiCanu** による HiFi ベース de novo アセンブリ  
2. 光学マップと統合しハイブリッドスキャフォールディング  
3. **SALSA2** による Hi-C ベースの再スキャフォールディング  
4. **RagTag** を用いた染色体レベルの構築（mRatBN7.2 をテンプレート）  
5. **CLR contig** によるギャップフィリング  
6. **Pilon + Illumina** による塩基精度の修正  
7. **Sanger Rapid Curation（Hi-C heatmap）** による最終手動キュレーション

---

## 主要な結果と考察

### 1. アセンブリ品質の大幅改善


### 2. 染色体配列の大幅な増加（Table 3）

特に増加が顕著だったのは：

- **Chr Y：+226%（18→59 Mb）**  
- **Chr 19：+29%（+16.9 Mb）**  
- **Chr 3, 11, 12：rDNA（NOR）領域の大規模拡張**  

いずれも mRatBN7.2 では欠落していた反復配列・ヘテロクロマチン領域である。

### 3. セントロメア・テロメアの解析（Table 1, 2 / Fig.3）

StainedGlass（Fig.3）を用いた自己相同性解析により：

- **多くの染色体で 0.5–5 Mb のセントロメア反復配列が新たに出現**
- テロメア六量体（TTAGGG）も多数の染色体で**長大化**して検出（特にメタセントリック染色体）

→ 以前のラット参照では欠落していた高反復領域の大規模回収に成功。

### 4. 新規遺伝子の追加（NCBI RefSeq Annotation）

- **1,100 以上の新規タンパク質コード遺伝子が追加**  
- そのうち：
  - **780：以前は未配置（unmapped）で mRatBN7.2 では位置不明**  
  - **373：既存領域にあったが未注釈（novel）**

特に Chr19 には **Speer関連遺伝子（精巣特異的）** が多数クラスター化（Fig.5）。  
Iso-Seq でも豊富に発現が確認され、**性染色体ドライブに伴う反復拡張**が示唆された。

### 5. PAR（擬似常染色体領域）の再検討（Table 5）

- ヒトでは X-Y に多数の PAR 遺伝子が存在  
- マウスではわずか 2 遺伝子  
- **ラット（GRCr8）では PAR 遺伝子はさらに消失／転座**  
  - 16 遺伝子のうち **12 が常染色体へ、4 は完全消失**
- ラットは **PAR機能がほぼ欠損した哺乳類**であり、  
  X-Y 間組換えはほぼ行われない可能性が高い。

### 6. 構造変異解析（Table 4）

mRatBN7.2 との比較で、

- 大規模な“未整合領域（not aligned）”が 160 Mb  
- 多数の“segmental duplication / inversion / translocation”が修正  
- Y染色体の遠位領域（ヘテロクロマチン）は GRCr8 で初めて大規模に出現（Fig.4）

---

## 新規性・意義

- **高精度 HiFi による最初のラット参照ゲノム**  
- これまで欠落していた **セントロメア・テロメア・Y染色体・rDNAクラスター** を大幅に回収  
- 多数の**新規遺伝子（特に生殖系列・testis発現遺伝子）**を追加  
- 構造異常の修正により **mRatBN7.2 の限界を抜本的に改善**

この改良により、以下が大きく前進する。

- 遺伝変異の解釈（GWAS / QTL）  
- 遺伝子改変ラットの作製とアレル解析  
- 性差・生殖生物学・行動神経科学  
- 反復配列（rDNA/Satellites）やゲノム構造の研究

---

## 限界と今後の展望

**限界**

- Telomere-to-telomere（T2T）には未到達  
- 特に rDNA クラスター・巨大衛星配列は HiFi でも完全解決は困難  
- 一部のギャップは CLR で埋めており、完全精度ではない可能性

**今後の展望**

- ONT ultra-long など“極長リード”を組み合わせた T2T アセンブリ  
- 近交系ラット（SHR、F344 など）の高精度ゲノム整備  
- Speer クラスターなど**性染色体ドライブ関連領域**の機能解析  
- RGD によるアノテーション強化

---

## 読後の感想

