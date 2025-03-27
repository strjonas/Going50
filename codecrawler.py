#!/usr/bin/env python3
"""
Project Files Extractor - Crawls through directories to extract content from LaTeX, Markdown, 
and other specified files into a single text file for analysis.
"""

import os
import argparse
import fnmatch
from datetime import datetime

def extract_files(root_dirs, output_file, file_patterns, exclude_dirs=None, max_file_size=10485760):
    """
    Crawls through directories and extracts content from matching files into a single output file.
    
    Args:
        root_dirs (list): List of root directories to crawl
        output_file (str): Path to output file
        file_patterns (list): List of file patterns to match (e.g., '*.tex', '*.md')
        exclude_dirs (list): List of directory patterns to exclude
        max_file_size (int): Maximum file size in bytes to process (default: 10MB)
    """
    if exclude_dirs is None:
        exclude_dirs = ['.git', 'node_modules', 'build', '.dart_tool', '.idea', '.vscode', 'ios', 'android', 'web']
    
    with open(output_file, 'w', encoding='utf-8') as outfile:
        # Write header
        outfile.write(f"# Project Files Extraction\n")
        outfile.write(f"# Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        outfile.write(f"# Root directories: {', '.join(root_dirs)}\n")
        outfile.write(f"# File patterns: {', '.join(file_patterns)}\n\n")
        
        total_files = 0
        skipped_files = 0
        processed_files = 0
        
        for root_dir in root_dirs:
            outfile.write(f"\n\n{'='*80}\n")
            outfile.write(f"DIRECTORY: {root_dir}\n")
            outfile.write(f"{'='*80}\n\n")
            
            for dirpath, dirnames, filenames in os.walk(root_dir):
                # Filter out excluded directories
                dirnames[:] = [d for d in dirnames if not any(fnmatch.fnmatch(d, pat) for pat in exclude_dirs)]
                
                # Process matching files
                for pattern in file_patterns:
                    for filename in fnmatch.filter(filenames, pattern):
                        total_files += 1
                        filepath = os.path.join(dirpath, filename)
                        
                        # Check file size
                        try:
                            file_size = os.path.getsize(filepath)
                            if file_size > max_file_size:
                                skipped_files += 1
                                print(f"Skipping large file: {filepath} ({file_size/1024/1024:.2f} MB)")
                                continue
                                
                            # Add file separator with metadata
                            rel_path = os.path.relpath(filepath, root_dir)
                            outfile.write(f"\n\n{'#'*80}\n")
                            outfile.write(f"FILE: {rel_path}\n")
                            outfile.write(f"{'#'*80}\n\n")
                            
                            # Read and write file content
                            try:
                                with open(filepath, 'r', encoding='utf-8') as infile:
                                    content = infile.read()
                                    outfile.write(content)
                                    processed_files += 1
                            except UnicodeDecodeError:
                                try:
                                    # Try with latin-1 encoding if utf-8 fails
                                    with open(filepath, 'r', encoding='latin-1') as infile:
                                        content = infile.read()
                                        outfile.write(content)
                                        processed_files += 1
                                except Exception as e:
                                    skipped_files += 1
                                    outfile.write(f"[ERROR: Could not read file due to encoding issues: {str(e)}]\n")
                            except Exception as e:
                                skipped_files += 1
                                outfile.write(f"[ERROR: {str(e)}]\n")
                                
                        except Exception as e:
                            skipped_files += 1
                            print(f"Error processing {filepath}: {str(e)}")
        
        # Write summary
        outfile.write(f"\n\n{'='*80}\n")
        outfile.write(f"SUMMARY\n")
        outfile.write(f"{'='*80}\n\n")
        outfile.write(f"Total files found: {total_files}\n")
        outfile.write(f"Files processed: {processed_files}\n")
        outfile.write(f"Files skipped: {skipped_files}\n")
    
    print(f"\nExtraction complete!")
    print(f"Total files found: {total_files}")
    print(f"Files processed: {processed_files}")
    print(f"Files skipped: {skipped_files}")
    print(f"Output written to: {output_file}")

def main():
    parser = argparse.ArgumentParser(description='Extract content from LaTeX, Markdown, and code files into a single text file.')
    parser.add_argument('--dirs', nargs='+', required=True, help='Root directories to crawl')
    parser.add_argument('--output', required=True, help='Output file path')
    parser.add_argument('--patterns', nargs='+', default=['*.tex', '*.md', '*.dart', '*.yaml', '*.txt', '*.json'],
                        help='File patterns to match (default: *.tex *.md *.dart *.yaml *.txt *.json)')
    parser.add_argument('--exclude-dirs', nargs='+', 
                        default=['.git', 'node_modules', 'build', '.dart_tool', '.idea', '.vscode', 'ios', 'android', 'web'],
                        help='Directory patterns to exclude')
    parser.add_argument('--max-size', type=int, default=10, 
                        help='Maximum file size in MB (default: 10)')
    
    args = parser.parse_args()
    max_file_size = args.max_size * 1024 * 1024  # Convert MB to bytes
    
    extract_files(args.dirs, args.output, args.patterns, args.exclude_dirs, max_file_size)

if __name__ == "__main__":
    main()