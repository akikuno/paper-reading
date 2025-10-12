# Harmonizing mouse anatomy terminology: a common language?

## 引用論文のリンク

https://link.springer.com/article/10.1007/s00335-025-10156-6  

## 引用論文のコピーライト

CC-BY 4.0  

---

## 背景：マウス解剖学における命名規則の不確かさ

マウスは依然としてヒト疾患研究の主要モデルであり、遺伝子改変技術・画像解析・表現型解析の発展により、その解剖学的情報は急速に蓄積している。  
しかし、Ruberteらは「マウス解剖学がすでに確立された分野である」という一般的認識が誤りであると警鐘を鳴らす。  

現状の問題点は以下の通りである。  
- 用語の出典が不明確  
- 文献・データベース間で命名体系が不一致  
- NAV（Nomina Anatomica Veterinaria）との整合性欠如  
- ヒトのTA（Terminologia Anatomica）用語を無批判に流用  

この混乱は、19世紀のヒト解剖学における用語混乱期（O’Rahilly, 1989）と酷似しており、  
表現型オントロジー統合やデータ比較を著しく妨げている。

> [!NOTE]
> NAV（Nomina Anatomica Veterinaria）：すべての哺乳類に共通する標準命名体系  
> - 英語版（6th Ed., 2017）: https://www.vetmed.uni-leipzig.de/fileadmin/Fakult%C3%A4t_VMF/Institut_Veterin%C3%A4r-Anatomisches/Dokumente/NAV_6th-Edition-2017.pdf  
> - 日本語版: https://www.jpn-ava.com/wp_new/wp-content/themes/ava_public_wp/data/glossary/navj_6th_ed.pdf  

> [!NOTE]
> TA（Terminologia Anatomica）：ヒト解剖学の国際標準命名体系  
> - http://terminologia-anatomica.org/en/Terms  

---

## 事例1：肝臓

マウスとヒトでは肝葉構造が大きく異なる。  
- マウス：4葉＋4亜葉＋2突起（NAV基準）  
- ヒト：右葉・左葉・方形葉・尾状葉（TA基準）  

Ruberteらは13冊の書籍、11報の論文、3つのデータベースを比較し、  
NAVで定義された8つの標準用語（右内・右外・左内・左外・方形葉・尾状葉2突起）に対して、  
**36種類もの異称が使用されている**ことを報告した。  
（例："middle lobe"、"median lobe"、"omental lobe"、"mamillary process"など）

さらに、  
- 存在しない「quadrate lobe（方形葉）」の誤記載  
- “papillary process”を“omental lobe”と誤称  
- “superior/inferior”といったヒト基準（TA由来）の上下表現の混用  

などの不統一が見られた。  
NAV準拠を明示していたのは、**わずか3冊の書籍と2報の論文**に過ぎない。  

このような不整合は、UBERONやFMAでの相同性マッピング（例："Right lateral lobe" ↔ "Posterior segment of right lobe"）を阻害する。

> [!NOTE]
> UBERON（Uber-anatomy Ontology）：多種間で共通する解剖構造を記述するオントロジー  
> - https://www.ebi.ac.uk/ols/ontologies/uberon  
> FMA（Foundational Model of Anatomy）：ヒト解剖学を体系的に記述したオントロジー  
> - https://bioportal.bioontology.org/ontologies/FMA  

---

## 事例2：前肢筋

マウス筋系の解剖情報は断片的で、既存文献中の筋リストはNAV登録数の**半数以下**にとどまる。  
さらに、古典的用語（例："flexor digitorum sublimis"）や、ヒトに特有の変異筋（例："dorsoepitrochlearis"）が混用されている。  

画像解析（MRI、µCT）の高精度化により形態認識は進んでいるが、  
**解剖学的境界の定義が曖昧なままでは、発生学的・機能学的比較に齟齬が生じる。**

---

## 旧来用語とエポニムの残存

NAV・TAからは既に除外された**人名由来エポニム**が、依然として使用されている。  

| 旧称（非推奨）         | 正式名称（推奨）                                                                                |
| ---------------------- | ----------------------------------------------------------------------------------------------- |
| Wharton’s duct         | submandibular duct（顎下腺管）                                                                  |
| Chassaignac’s tubercle | anterior tubercle of the transverse process of the 6th cervical vertebra（第6頸椎横突起前結節） |
| Innominate artery      | brachiocephalic trunk（腕頭動脈）                                                               |

これらのエポニムは非記述的・曖昧・教育上の障壁となるため、  
国際的にも使用は推奨されない。

> [!TIP]
> 例えば“Wharton’s duct”と呼んでも部位がわからないが、  
> “submandibular duct（顎下腺管）”とすれば、解剖的位置が直感的に理解できる。  

多くの学術誌が採用用語体系（例：NAV準拠）を明記していないことも、エポニム残存の一因とされる。

---

## 「自己流解剖（Do-it-yourself anatomy）」の危険性

形態学専門家の減少により、非専門の研究者が自ら解剖・命名する事例が増加している。  
その結果、  
- ヒトに存在しない器官（例：preputial gland）を病変と誤認  
- 手術・切除プロトコルにおける領域境界の誤記載  

など、**形態学的誤認 → 表現型誤注釈 → データ不整合**という連鎖が生じている。

---

## 新構造の発見と命名課題

新技術の進展により、NAVに未登録の構造が次々に報告されている。  
例：  
- apical splenic nerve（脾尖神経）：当初は神経とされたが、後に結合組織束である可能性が指摘（Guyot et al., 2019; Cleypool et al., 2022）。  
- interscapular fat pad（肩甲間脂肪体）：褐色脂肪組織を示すが、NAVでは未定義。  

これらは、**現行命名体系のカバレッジ不足**と**新構造・新機能に対応する語彙体系の必要性**を示唆する。

---

## 著者らの提案

### ① 専門家ワーキンググループの設立

比較解剖学者・病態モデル研究者が協働し、臓器系ごとに文献・オントロジーを精査して  
**NAV準拠の合意用語リスト**を策定する。  

この際、MA（Adult Mouse Anatomy）、EMAPA、UBERONと照合し、  
**ヒト・他動物間での相同性マッピング**を体系的に整備する。

> [!NOTE]
> MA（Adult Mouse Anatomy）：成体マウスの解剖学構造オントロジー  
> - https://www.ebi.ac.uk/ols/ontologies/ma  
> EMAPA（Edinburgh Mouse Atlas Project Anatomy）：発生段階を含むマウス解剖オントロジー  
> - https://www.ebi.ac.uk/ols/ontologies/emapa  

---

### ② 中央アナトミーリポジトリ（Corpus Anatomicum）の構築

画像・3D情報・用語を統合した中央データベースを構築し、  
MA・EMAPAの更新を通じて教育・研究・データ注釈の標準化を図る。  

これにより、表現型解析（IMPC等）や遺伝子発現データ（GXD）との相互運用性を高め、  
UBERONを介したオントロジー統合が促進される。

---

## 読後の感想

医学部の解剖実習では「TA（Terminologia Anatomica）」について明示的に教わった記憶がなく（私がただ忘れただけだと思うが）、ましてや「NAV（Nomina Anatomica Veterinaria）」については今回初めて知ることができた。医学系の教育・研究環境では、どうしてもヒトの解剖学体系を前提に議論してしまいがちであり、マウスとの構造的・命名的な差異を見落としがちになる。しかし、動物モデルを用いた研究では、こうした差異の意識こそが正確な比較・注釈の基礎になると痛感した。

また、UBERON以外に「MA（Adult Mouse Anatomy）」や「EMAPA（Edinburgh Mouse Atlas Project Anatomy）」といったマウス特有のオントロジーが存在することを知り、有益であった。遺伝子発現データベースGXDや細胞オントロジーCO（Cell Ontology）との対応関係にも注目し、細胞・組織・器官をまたいだ統合的なバイオインフォマティクス解析に応用できるよう学習を進めたい。
