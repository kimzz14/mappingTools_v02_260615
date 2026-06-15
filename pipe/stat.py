import glob

fout = open('stat.txt', 'w')

for fileName1 in glob.glob('result/*.flagstat'):
    readID = fileName1.split('/')[1].split('.bwa-memT')[0]

    fin1 = open(fileName1)
    mapped = 0
    for lineIDX, line in enumerate(fin1):
        if lineIDX == 0: total = int(line.rstrip('\n').split(' ')[0])
        if lineIDX == 4: mapped = int(line.rstrip('\n').split(' ')[0])
        if lineIDX == 5: paired = int(line.rstrip('\n').split(' ')[0])
        if lineIDX == 8: properly = int(line.rstrip('\n').split(' ')[0])
    fin1.close()

    depth01 = 0
    for fileName2 in glob.glob(f'result/{readID}*.byChrom/*.depth_01'):
        fin2 = open(fileName2)
        for lineIDX, line in enumerate(fin2):
            depth01 += int(line.rstrip('\n'))
        fin2.close()
    
    depth05 = 0
    for fileName2 in glob.glob(f'result/{readID}*.byChrom/*.depth_05'):
        fin2 = open(fileName2)
        for lineIDX, line in enumerate(fin2):
            depth05 += int(line.rstrip('\n'))
        fin2.close()

    depth10 = 0
    for fileName2 in glob.glob(f'result/{readID}*.byChrom/*.depth_10'):
        fin2 = open(fileName2)
        for lineIDX, line in enumerate(fin2):
            depth10 += int(line.rstrip('\n'))
        fin2.close()

    if paired != 0:
        fout.write(f'{readID}\t{mapped/total}\t{properly/paired}\t{depth01}\t{depth05}\t{depth10}\n')
    else:
        fout.write(f'{readID}\t{mapped/total}\t{0}\t{depth01}\t{depth05}\t{depth10}\n')
fout.close()
