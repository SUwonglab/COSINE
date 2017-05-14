# COSINE

COINE is an aligner tool for mapping long noisy reads (e.g. TGS reads)

## Command options

Type `cosine -h` for list of command options and default values.

```
    --ref_filename STR         : input reference filename 
    --read_filename STR        : input read filename
    --output_ref_prefix STR    : reference index file prefix
    --output_read_prefix STR   : output prefix for alignment results
    
    --save_ref_fft             : index reference file

    --num_threads INT          : number of threads in dynamic programming step [1]
        
    --kmer_size INT            : k-mer size (recommended: 3 or 4) [3]
        
    --window_size INT          : window size [500]
    --window_shift INT         : distance between consecutive windows [10]
        
    --max_read_size INT        : maximum read fragment size [5000] 
                                 Split longer reads to < INT fragments

    --peak_search_window FLOAT : segment size (FLOAT * read_length) to search local maximum peaks
    --max_num_moments_peaks INT: maximum number of local peaks in each iteration to estimate mean and std [1000]
    
    --max_num_top_peaks INT    : maximum number of top peaks per fragment to be selected for dynamic programming step [10]
    --min_peak_significance_metric    FLOAT : minimum significance metric (mean + FLOAT * std)
    --peak_significance_metric_margin FLOAT : maximum margin (FLOAT * std) of a significant peak to the top peak value 

    --min_dp_score INT         : minimum dynamic programming score
    --dp_guided_band_len       : band length (2 x INT) in BDP 
    
    --m_match INT              : match score [1]
    --m_mismatch INT           : mismatch score [-1]
    --m_gap_open INT           : gap open score [-1]
    --m_gap_ext INT            : gap extension score [-1]
    --ins_portion              : maximum expected ins rate. [.6]
                                 This parameter is used in dynamic programming step.
    --del_portion              : maximum expected del rate. [.3]
                                 This parameter is used in dynamic programming step.
    --max_error_rate           : maximum expected error rate. [.6]
                                 This parameter is used in dynamic programming step.

    --fft_block_size INT       : fft block size [32768]
    --max_num_fft_blocks INT   : number of FFT blocks to be processed simultaneously.
                                 This parameter depends on GPU memory. 
    --max_fft_segment_size INT : maximum size of FFT segments.
                                 This parameter depends on GPU memory.
                                 Either set this or max_num_fft_blocks parameter.
                                 
    --seed                     : seed value for rand() 
                                 In order to replicate exact same results.
    --use_seed                 : use seed value to initialize rand() 
 
```
## Examples

#### Generate index (FFT blocks) 
Index file depends on fft_block_size, kmer_size, max_read_size, window_size and window shift parameters.  

```
    bin/cosine --ref_filename sample_data/Ecoli.fa \
               --output_ref_prefix sample_out/Ecoli \
               --fft_block_size 32768  \
               --kmer_size 3 \
               --max_read_size 5000 \
               --window_size 500 \
               --window_shift 100 \
               --seed 0 \
               --save_ref_fft 1
```

Generated index files are *.bfft (binary) and *.header which has information on parameter settings and reference sequences.

```
> more Ecoli.header
@HD     1.00    KS:3    WL:500  WS:10   FL:32768        RS:5000 NS:1
@SQ     SN:U00096.3     LN:4641652      KN:464155       BN:15
```

@HD  
1.00: COSINE version  
KS: k-mer size  
WL: window size  
WS: window shift  
FL: FFT block size  
RS: maximum read size  
NS: number of sequences in the reference file  

@FQ [per sequence]  
SN: sequence name  
LN: sequence length  
KN: length of sequence k-mer count vector  
BN: number of FFT blocks  

#### Run alignment  

```
    bin/cosine --ref_filename sample_data/Ecoli.fa \
               --read_filename sample_data/Ecoli_reads_acc85.fa \
               --output_ref_prefix sample_out/Ecoli \
               --output_read_prefix sample_out/Ecoli_reads_acc85 \
               --fft_block_size 32768  \
               --max_num_fft_blocks 15 \
               --num_threads 10 \
               --kmer_size 3 \
               --max_read_size 5000 \
               --window_size 500 \
               --window_shift 100   \
               --min_dp_score 100 \
               --seed 1
```

Generated output files are \*.sam (alignments) and intermediate file with detected peak information per read (*.peaks)  

#### Suggested settings for Pacbio and ONT reads

For higher quality reads, it is recommened to use ```--kmer_size 3```. It run 2-3x faster than ```--kmer_size 4``` without noticable perfromane loss.  
For ONT reads, we suggest the setting of ```--window_size 100 --window_shift 10 ```, and  
for PacBio reads, the setting of ```--window_size 250 --window_shift 50 ``` for optimal performance.

## System Requirement

Current implementation of COSINE is on NVIDIA GPU. It requires cufft and curand libraries from NVIDIA.  

## Cite

Under review.

## License

Academic [license](S15-309_academic_software_license.pdf) 

Please contact [Wong lab](http://web.stanford.edu/group/wonglab/index.html) for any commercial license.

