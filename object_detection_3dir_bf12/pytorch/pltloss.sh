grep maskrcnn_benchmark.trainer l1.log                                        |awk '{if($5=="eta:"){ if($7=="iter:") {xx=$8;yy=$10 ;zz=substr($11,2,length($11)-2)}else {xx=$10;yy=$12;zz=substr($13,2,length($13)-2)};if (xx%1000 == 0 ){print  xx " " yy " " zz}}}' > fp32_1.loss
grep maskrcnn_benchmark.trainer ../../object_detection_BF16/pytorch/bf16_1.log|awk '{if($5=="eta:"){ if($7=="iter:") {xx=$8;yy=$10 ;zz=substr($11,2,length($11)-2)}else {xx=$10;yy=$12;zz=substr($13,2,length($13)-2)};if (xx%1000 == 0 ){print  xx " " yy " " zz}}}' > bf16_1.loss
grep maskrcnn_benchmark.trainer bf16_3dir_1.log                               |awk '{if($5=="eta:"){ if($7=="iter:") {xx=$8;yy=$10 ;zz=substr($11,2,length($11)-2)}else {xx=$10;yy=$12;zz=substr($13,2,length($13)-2)};if (xx%1000 == 0 ){print  xx " " yy " " zz}}}' > bf16_3dir_1.loss

grep maskrcnn_benchmark.trainer l1.log                                        |awk '{if($5=="eta:") { if($7=="iter:") {save=$8} else {save=$10} } else if ($6=="mAP:") {print save " " $7 " " $10} }' > fp32_1.map
grep maskrcnn_benchmark.trainer ../../object_detection_BF16/pytorch/bf16_1.log|awk '{if($5=="eta:") { if($7=="iter:") {save=$8} else {save=$10} } else if ($6=="mAP:") {print save " " $7 " " $10} }' > bf16_1.map
grep maskrcnn_benchmark.trainer bf16_3dir_1.log                               |awk '{if($5=="eta:") { if($7=="iter:") {save=$8} else {save=$10} } else if ($6=="mAP:") {print save " " $7 " " $10} }' > bf16_3dir_1.map

gnuplot -p -e '
  set key left top;
  set xlabel "Iteration";
  set ylabel "loss";
  set y2label "mAP(bbox/segm)";
  set ytics nomirror; 
  set y2tics 0.1,0.01;
  plot 
    0.377                             axis x1y2 title "BBOX mAP target", 
    0.339                             axis x1y2 title "SEGM mAP target", 
    "fp32_1.map"       u 1:2 w linesp axis x1y2 title "FP32 BBOX mAP", 
    "fp32_1.map"       u 1:3 w linesp axis x1y2 title "FP32 SEGM mAP", 
    "fp32_1.loss"      u 1:2          axis x1y1 title "FP32 loss", 
    "bf16_1.map"       u 1:2 w linesp axis x1y2 title "BF16 BBOX mAP", 
    "bf16_1.map"       u 1:3 w linesp axis x1y2 title "BF16 SEGM mAP", 
    "bf16_1.loss"      u 1:2          axis x1y1 title "BF16 loss" lt rgb "violet",
    "bf16_3dir_1.map"  u 1:2 w linesp axis x1y2 title "BF16 3dir BBOX mAP", 
    "bf16_3dir_1.map"  u 1:3 w linesp axis x1y2 title "BF16 3dir SEGM mAP", 
    "bf16_3dir_1.loss" u 1:2          axis x1y1 title "BF16 3dir loss"
'
#gnuplot -p -e 'set key left top;set xlabel "Iteration";set ylabel "loss";set y2label "mAP(bbox/segm)";set ytics nomirror; set y2tics 0.1,0.01;plot "fp32_1.map" u 1:2 w linesp axis x1y2 title "FP32 BBOX mAP", "fp32_1.map" u 1:3 w linesp axis x1y2 title "FP32 SEGM mAP", "fp32_1.loss" u 1:2 axis  x1y1 title "FP32 loss","fp32_1.loss" u 1:3 axis  x1y1 w linesp title "FP32 loss avg" ,  "bf16_1.map" u 1:2 w linesp axis x1y2 title "BF16 BBOX mAP", "bf16_1.map" u 1:3 w linesp axis x1y2 title "BF16 SEGM mAP", "bf16_1.loss" u 1:2 axis  x1y1 title "BF16 loss" lt rgb "violet"'
#gnuplot -p -e 'set size 2,1 ; set multiplot layout 2,1; set ylabel "mAP(bbox/segm)";plot "fp32_1.map" u 1:2 w linesp title "FP32 BBOX mAP", "fp32_1.map" u 1:3 w linesp title "FP32 SEGM mAP", "bf16_1.map" u 1:2 w linesp title "BF16 BBOX mAP", "bf16_1.map" u 1:3 w linesp  title "BF16 SEGM mAP"; set xlabel "Iteration";set ylabel "Loss"; plot "fp32_1.loss" u 1:2  title "FP32 loss",  "bf16_1.loss" u 1:2  title "BF16 loss" ;unset multiplot'

