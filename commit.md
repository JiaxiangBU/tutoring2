
``` python
for i,(j,x) in enumerate(df_raw.groupby(['cut','clarity'])):
    if i <= 0:
        print(i,j,x)
        print(x.__class__)
        x_series = x.groupby('color')['n'].sum()/x['n'].sum()
        print(x_series.__class__)
        x_df = x_series.to_frame().T
        print(x_df.shape)
```

    0 ('Fair', 'I1')      cut color clarity   n
    0   Fair     D      I1   4
    8   Fair     E      I1   9
    15  Fair     F      I1  35
    23  Fair     G      I1  53
    31  Fair     H      I1  52
    38  Fair     I      I1  34
    45  Fair     J      I1  23
    <class 'pandas.core.frame.DataFrame'>
    <class 'pandas.core.series.Series'>
    (1, 7)

因此充分了解其中的结构，固定进行转置`.T`，而不要借助 `groupby` 合并时，默认转置。

``` python
df_raw.groupby(['cut','clarity']).apply(lambda x: pd.DataFrame(x.groupby('color')['n'].sum()/x['n'].sum()).T)
```

<details>

<summary>结果太长。</summary>

<div>

<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>

<table border="1" class="dataframe">

<thead>

<tr style="text-align: right;">

<th>

</th>

<th>

</th>

<th>

</th>

<th>

D

</th>

<th>

E

</th>

<th>

F

</th>

<th>

G

</th>

<th>

H

</th>

<th>

I

</th>

<th>

J

</th>

</tr>

<tr>

<th>

cut

</th>

<th>

clarity

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

</tr>

</thead>

<tbody>

<tr>

<th rowspan="8" valign="top">

Fair

</th>

<th>

I1

</th>

<th>

n

</th>

<td>

0.019048

</td>

<td>

0.042857

</td>

<td>

0.166667

</td>

<td>

0.252381

</td>

<td>

0.247619

</td>

<td>

0.161905

</td>

<td>

0.109524

</td>

</tr>

<tr>

<th>

IF

</th>

<th>

n

</th>

<td>

0.333333

</td>

<td>

NaN

</td>

<td>

0.444444

</td>

<td>

0.222222

</td>

<td>

NaN

</td>

<td>

NaN

</td>

<td>

NaN

</td>

</tr>

<tr>

<th>

SI1

</th>

<th>

n

</th>

<td>

0.142157

</td>

<td>

0.159314

</td>

<td>

0.203431

</td>

<td>

0.169118

</td>

<td>

0.183824

</td>

<td>

0.073529

</td>

<td>

0.068627

</td>

</tr>

<tr>

<th>

SI2

</th>

<th>

n

</th>

<td>

0.120172

</td>

<td>

0.167382

</td>

<td>

0.190987

</td>

<td>

0.171674

</td>

<td>

0.195279

</td>

<td>

0.096567

</td>

<td>

0.057940

</td>

</tr>

<tr>

<th>

VS1

</th>

<th>

n

</th>

<td>

0.029412

</td>

<td>

0.082353

</td>

<td>

0.194118

</td>

<td>

0.264706

</td>

<td>

0.188235

</td>

<td>

0.147059

</td>

<td>

0.094118

</td>

</tr>

<tr>

<th>

VS2

</th>

<th>

n

</th>

<td>

0.095785

</td>

<td>

0.160920

</td>

<td>

0.203065

</td>

<td>

0.172414

</td>

<td>

0.157088

</td>

<td>

0.122605

</td>

<td>

0.088123

</td>

</tr>

<tr>

<th>

VVS1

</th>

<th>

n

</th>

<td>

0.176471

</td>

<td>

0.176471

</td>

<td>

0.294118

</td>

<td>

0.176471

</td>

<td>

0.058824

</td>

<td>

0.058824

</td>

<td>

0.058824

</td>

</tr>

<tr>

<th>

VVS2

</th>

<th>

n

</th>

<td>

0.130435

</td>

<td>

0.188406

</td>

<td>

0.144928

</td>

<td>

0.246377

</td>

<td>

0.159420

</td>

<td>

0.115942

</td>

<td>

0.014493

</td>

</tr>

<tr>

<th rowspan="8" valign="top">

Good

</th>

<th>

I1

</th>

<th>

n

</th>

<td>

0.083333

</td>

<td>

0.239583

</td>

<td>

0.197917

</td>

<td>

0.197917

</td>

<td>

0.145833

</td>

<td>

0.093750

</td>

<td>

0.041667

</td>

</tr>

<tr>

<th>

IF

</th>

<th>

n

</th>

<td>

0.126761

</td>

<td>

0.126761

</td>

<td>

0.211268

</td>

<td>

0.309859

</td>

<td>

0.056338

</td>

<td>

0.084507

</td>

<td>

0.084507

</td>

</tr>

<tr>

<th>

SI1

</th>

<th>

n

</th>

<td>

0.151923

</td>

<td>

0.227564

</td>

<td>

0.175000

</td>

<td>

0.132692

</td>

<td>

0.150641

</td>

<td>

0.105769

</td>

<td>

0.056410

</td>

</tr>

<tr>

<th>

SI2

</th>

<th>

n

</th>

<td>

0.206290

</td>

<td>

0.186864

</td>

<td>

0.185939

</td>

<td>

0.150786

</td>

<td>

0.146161

</td>

<td>

0.074931

</td>

<td>

0.049029

</td>

</tr>

<tr>

<th>

VS1

</th>

<th>

n

</th>

<td>

0.066358

</td>

<td>

0.137346

</td>

<td>

0.203704

</td>

<td>

0.234568

</td>

<td>

0.118827

</td>

<td>

0.158951

</td>

<td>

0.080247

</td>

</tr>

<tr>

<th>

VS2

</th>

<th>

n

</th>

<td>

0.106339

</td>

<td>

0.163599

</td>

<td>

0.188139

</td>

<td>

0.196319

</td>

<td>

0.141104

</td>

<td>

0.112474

</td>

<td>

0.092025

</td>

</tr>

<tr>

<th>

VVS1

</th>

<th>

n

</th>

<td>

0.069892

</td>

<td>

0.231183

</td>

<td>

0.188172

</td>

<td>

0.220430

</td>

<td>

0.166667

</td>

<td>

0.118280

</td>

<td>

0.005376

</td>

</tr>

<tr>

<th>

VVS2

</th>

<th>

n

</th>

<td>

0.087413

</td>

<td>

0.181818

</td>

<td>

0.174825

</td>

<td>

0.262238

</td>

<td>

0.157343

</td>

<td>

0.090909

</td>

<td>

0.045455

</td>

</tr>

<tr>

<th rowspan="8" valign="top">

Ideal

</th>

<th>

I1

</th>

<th>

n

</th>

<td>

0.089041

</td>

<td>

0.123288

</td>

<td>

0.287671

</td>

<td>

0.109589

</td>

<td>

0.260274

</td>

<td>

0.116438

</td>

<td>

0.013699

</td>

</tr>

<tr>

<th>

IF

</th>

<th>

n

</th>

<td>

0.023102

</td>

<td>

0.065182

</td>

<td>

0.221122

</td>

<td>

0.405116

</td>

<td>

0.186469

</td>

<td>

0.078383

</td>

<td>

0.020627

</td>

</tr>

<tr>

<th>

SI1

</th>

<th>

n

</th>

<td>

0.172349

</td>

<td>

0.178888

</td>

<td>

0.141990

</td>

<td>

0.154134

</td>

<td>

0.178188

</td>

<td>

0.117702

</td>

<td>

0.056749

</td>

</tr>

<tr>

<th>

SI2

</th>

<th>

n

</th>

<td>

0.137028

</td>

<td>

0.180523

</td>

<td>

0.174365

</td>

<td>

0.187067

</td>

<td>

0.173210

</td>

<td>

0.105466

</td>

<td>

0.042340

</td>

</tr>

<tr>

<th>

VS1

</th>

<th>

n

</th>

<td>

0.097799

</td>

<td>

0.165227

</td>

<td>

0.171636

</td>

<td>

0.265534

</td>

<td>

0.130120

</td>

<td>

0.113681

</td>

<td>

0.056004

</td>

</tr>

<tr>

<th>

VS2

</th>

<th>

n

</th>

<td>

0.181424

</td>

<td>

0.224019

</td>

<td>

0.173339

</td>

<td>

0.179452

</td>

<td>

0.109643

</td>

<td>

0.086373

</td>

<td>

0.045750

</td>

</tr>

<tr>

<th>

VVS1

</th>

<th>

n

</th>

<td>

0.070347

</td>

<td>

0.163654

</td>

<td>

0.214949

</td>

<td>

0.290181

</td>

<td>

0.159257

</td>

<td>

0.087445

</td>

<td>

0.014167

</td>

</tr>

<tr>

<th>

VVS2

</th>

<th>

n

</th>

<td>

0.108979

</td>

<td>

0.194551

</td>

<td>

0.199540

</td>

<td>

0.297007

</td>

<td>

0.110898

</td>

<td>

0.068304

</td>

<td>

0.020721

</td>

</tr>

<tr>

<th rowspan="8" valign="top">

Premium

</th>

<th>

I1

</th>

<th>

n

</th>

<td>

0.058537

</td>

<td>

0.146341

</td>

<td>

0.165854

</td>

<td>

0.224390

</td>

<td>

0.224390

</td>

<td>

0.117073

</td>

<td>

0.063415

</td>

</tr>

<tr>

<th>

IF

</th>

<th>

n

</th>

<td>

0.043478

</td>

<td>

0.117391

</td>

<td>

0.134783

</td>

<td>

0.378261

</td>

<td>

0.173913

</td>

<td>

0.100000

</td>

<td>

0.052174

</td>

</tr>

<tr>

<th>

SI1

</th>

<th>

n

</th>

<td>

0.155524

</td>

<td>

0.171748

</td>

<td>

0.170070

</td>

<td>

0.158322

</td>

<td>

0.183217

</td>

<td>

0.102657

</td>

<td>

0.058462

</td>

</tr>

<tr>

<th>

SI2

</th>

<th>

n

</th>

<td>

0.142760

</td>

<td>

0.175992

</td>

<td>

0.177348

</td>

<td>

0.166836

</td>

<td>

0.176670

</td>

<td>

0.105799

</td>

<td>

0.054595

</td>

</tr>

<tr>

<th>

VS1

</th>

<th>

n

</th>

<td>

0.065862

</td>

<td>

0.146807

</td>

<td>

0.145802

</td>

<td>

0.284565

</td>

<td>

0.168929

</td>

<td>

0.111111

</td>

<td>

0.076923

</td>

</tr>

<tr>

<th>

VS2

</th>

<th>

n

</th>

<td>

0.100983

</td>

<td>

0.187370

</td>

<td>

0.184391

</td>

<td>

0.214775

</td>

<td>

0.158475

</td>

<td>

0.093834

</td>

<td>

0.060173

</td>

</tr>

<tr>

<th>

VVS1

</th>

<th>

n

</th>

<td>

0.064935

</td>

<td>

0.170455

</td>

<td>

0.129870

</td>

<td>

0.277597

</td>

<td>

0.181818

</td>

<td>

0.136364

</td>

<td>

0.038961

</td>

</tr>

<tr>

<th>

VVS2

</th>

<th>

n

</th>

<td>

0.108046

</td>

<td>

0.139080

</td>

<td>

0.167816

</td>

<td>

0.316092

</td>

<td>

0.135632

</td>

<td>

0.094253

</td>

<td>

0.039080

</td>

</tr>

<tr>

<th rowspan="8" valign="top">

Very Good

</th>

<th>

I1

</th>

<th>

n

</th>

<td>

0.059524

</td>

<td>

0.261905

</td>

<td>

0.154762

</td>

<td>

0.190476

</td>

<td>

0.142857

</td>

<td>

0.095238

</td>

<td>

0.095238

</td>

</tr>

<tr>

<th>

IF

</th>

<th>

n

</th>

<td>

0.085821

</td>

<td>

0.160448

</td>

<td>

0.250000

</td>

<td>

0.294776

</td>

<td>

0.108209

</td>

<td>

0.070896

</td>

<td>

0.029851

</td>

</tr>

<tr>

<th>

SI1

</th>

<th>

n

</th>

<td>

0.152469

</td>

<td>

0.193210

</td>

<td>

0.172531

</td>

<td>

0.146296

</td>

<td>

0.168827

</td>

<td>

0.110494

</td>

<td>

0.056173

</td>

</tr>

<tr>

<th>

SI2

</th>

<th>

n

</th>

<td>

0.149524

</td>

<td>

0.211905

</td>

<td>

0.163333

</td>

<td>

0.155714

</td>

<td>

0.163333

</td>

<td>

0.095238

</td>

<td>

0.060952

</td>

</tr>

<tr>

<th>

VS1

</th>

<th>

n

</th>

<td>

0.098592

</td>

<td>

0.165070

</td>

<td>

0.165070

</td>

<td>

0.243380

</td>

<td>

0.144789

</td>

<td>

0.115493

</td>

<td>

0.067606

</td>

</tr>

<tr>

<th>

VS2

</th>

<th>

n

</th>

<td>

0.119259

</td>

<td>

0.194134

</td>

<td>

0.179853

</td>

<td>

0.184871

</td>

<td>

0.145118

</td>

<td>

0.105751

</td>

<td>

0.071015

</td>

</tr>

<tr>

<th>

VVS1

</th>

<th>

n

</th>

<td>

0.065906

</td>

<td>

0.215463

</td>

<td>

0.220532

</td>

<td>

0.240811

</td>

<td>

0.145754

</td>

<td>

0.087452

</td>

<td>

0.024081

</td>

</tr>

<tr>

<th>

VVS2

</th>

<th>

n

</th>

<td>

0.114170

</td>

<td>

0.241296

</td>

<td>

0.201619

</td>

<td>

0.244534

</td>

<td>

0.117409

</td>

<td>

0.057490

</td>

<td>

0.023482

</td>

</tr>

</tbody>

</table>

</div>

</details>

``` python
df_raw.groupby(['cut']).apply(lambda x: pd.DataFrame(x.groupby('color')['n'].sum()/x['n'].sum()).T)
```

<div>

<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>

<table border="1" class="dataframe">

<thead>

<tr style="text-align: right;">

<th>

</th>

<th>

color

</th>

<th>

D

</th>

<th>

E

</th>

<th>

F

</th>

<th>

G

</th>

<th>

H

</th>

<th>

I

</th>

<th>

J

</th>

</tr>

<tr>

<th>

cut

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

</tr>

</thead>

<tbody>

<tr>

<th>

Fair

</th>

<th>

n

</th>

<td>

0.101242

</td>

<td>

0.139130

</td>

<td>

0.193789

</td>

<td>

0.195031

</td>

<td>

0.188199

</td>

<td>

0.108696

</td>

<td>

0.073913

</td>

</tr>

<tr>

<th>

Good

</th>

<th>

n

</th>

<td>

0.134937

</td>

<td>

0.190175

</td>

<td>

0.185283

</td>

<td>

0.177538

</td>

<td>

0.143090

</td>

<td>

0.106400

</td>

<td>

0.062576

</td>

</tr>

<tr>

<th>

Ideal

</th>

<th>

n

</th>

<td>

0.131502

</td>

<td>

0.181105

</td>

<td>

0.177532

</td>

<td>

0.226625

</td>

<td>

0.144541

</td>

<td>

0.097118

</td>

<td>

0.041576

</td>

</tr>

<tr>

<th>

Premium

</th>

<th>

n

</th>

<td>

0.116235

</td>

<td>

0.169458

</td>

<td>

0.169023

</td>

<td>

0.212022

</td>

<td>

0.171126

</td>

<td>

0.103546

</td>

<td>

0.058589

</td>

</tr>

<tr>

<th>

Very Good

</th>

<th>

n

</th>

<td>

0.125228

</td>

<td>

0.198643

</td>

<td>

0.179109

</td>

<td>

0.190283

</td>

<td>

0.150968

</td>

<td>

0.099652

</td>

<td>

0.056117

</td>

</tr>

</tbody>

</table>

</div>
