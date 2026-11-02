# IgY-RIG: preliminary investment feasibility (November 2026)

เอกสารภาคผนวกประกอบข้อ 7 ของแบบเสนอโครงการขอรับทุน: **การวิเคราะห์ความเป็นไปได้ในการลงทุน IgY-RIG เบื้องต้น**

## Contents

- [`technical_appendix_th.md`](technical_appendix_th.md) — นิยามข้อมูล สูตรคำนวณ ผลวิเคราะห์ สมมติฐาน ข้อจำกัด และคำถามที่ต้องยืนยันกับทีมวิจัย
- [`reproduce_results.R`](reproduce_results.R) — R script แบบ base R สำหรับตรวจสอบผล NPV, PI, IRR, จุดคุ้มทุน และกรณีความต้องการจำกัด โดยไม่ต้องใช้แพ็กเกจเพิ่มเติม

## ข้อควรระวัง

ผลทั้งหมดเป็น **financial scenario analysis** ไม่ใช่การยืนยันความคุ้มค่าทางสังคม (social B/C ratio) หรือการวิเคราะห์ cost-effectiveness และยังไม่ใช่ข้อเสนออนุมัติลงทุน GMP เต็มรูปแบบ ข้อมูลบางรายการเป็นประมาณการ/สมมติฐาน และมีประเด็นนิยามผู้ต้องรับ RIG ที่ต้องตรวจสอบก่อนส่งข้อเสนอฉบับสมบูรณ์

## Provenance

คำนวณจากไฟล์ต้นฉบับที่ทีมส่งให้:

1. `IgY_RIG_Early_HTA_Working_Model_CT.xlsx` (แท็บ `HTA Model Inputs CT`, `HTA Cost and Investment CT`)
2. `IgY_RIG_parameters_2026-11-01_a.csv` และ `IgY_RIG_parameters_2026-11-01_b.csv`
3. ข้อมูลที่ทีมแจ้งว่าเก็บถึง 29 ตุลาคม 2569: สัมผัสสัตว์ 1,451,921; ต้องรับวัคซีน 702,567; มีข้อบ่งชี้ RIG 594,928 (84.68%)

ไฟล์ต้นฉบับ **ไม่ได้รวมอยู่ในชุดเผยแพร่นี้** เพื่อให้เจ้าของข้อมูลพิจารณาอนุญาตก่อน หากต้องการเผยแพร่ต่อสาธารณะ ควรยืนยันนิยามข้อมูลและสิทธิในการเผยแพร่ก่อนเปิด repository เป็น public

## How to reproduce

เปิด R แล้วรัน:

```r
source('reproduce_results.R')
```

ตัวเลขในสคริปต์เป็น *snapshot* ของค่าที่ใช้จัดทำเอกสาร ไม่ได้อ่าน Excel/CSV โดยอัตโนมัติ การแก้ไขไฟล์ต้นทางภายหลังจึงไม่เปลี่ยนผลลัพธ์จนกว่าจะปรับสคริปต์

## Suggested citation

IgY-RIG research and modelling team. *Preliminary IgY-RIG investment feasibility: model assumptions and sensitivity scenarios*. Working technical appendix, November 2026. (Internal draft; confirm team authorship and version before public release.)
