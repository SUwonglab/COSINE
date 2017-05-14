# Generate ref index
../bin/cosine  --ref_filename Ecoli.fa \
               --output_ref_prefix Ecoli \
               --fft_block_size 32768  \
               --kmer_size 3 \
               --max_read_size 5000 \
               --window_size 500 \
               --window_shift 100   \
               --save_ref_fft 1
# Align reads
../bin/cosine  --ref_filename Ecoli.fa \
               --read_filename reads.fa \
               --output_ref_prefix Ecoli \
               --output_read_prefix reads \
               --fft_block_size 32768  \
               --max_num_fft_blocks 15 \
               --num_threads 10 \
               --kmer_size 3 \
               --max_read_size 5000 \
               --window_size 500 \
               --window_shift 100   \
               --min_dp_score 100
