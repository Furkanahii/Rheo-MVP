#!/usr/bin/env python3
"""
Rheo Question Generator - Main Script
Tüm generator modüllerini çalıştırır ve questions.json üretir.

Kullanım:
    python main.py [--count N]

Örnek:
    python main.py --count 50
"""

import json
import argparse
import random
from pathlib import Path
from generator import VariableGenerator, IfElseGenerator, LoopGenerator


def generate_questions(count_per_topic: int = 10) -> list:
    """Her topic için belirtilen sayıda soru üretir."""
    
    generators = [
        VariableGenerator(),
        IfElseGenerator(),
        LoopGenerator(),
    ]
    
    all_questions = []
    
    for gen in generators:
        questions = gen.generate(count=count_per_topic)
        all_questions.extend([q.to_dict() for q in questions])
    
    # Soruları karıştır
    random.shuffle(all_questions)
    
    return all_questions


def save_to_json(questions: list, output_path: Path) -> None:
    """Soruları JSON dosyasına kaydeder."""
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(questions, f, ensure_ascii=False, indent=2)
    
    print(f"✅ {len(questions)} soru üretildi: {output_path}")


def main():
    parser = argparse.ArgumentParser(description='Rheo Soru Üretici')
    parser.add_argument(
        '--count', 
        type=int, 
        default=10,
        help='Her topic için üretilecek soru sayısı (default: 10)'
    )
    args = parser.parse_args()
    
    # Output path
    script_dir = Path(__file__).parent
    output_path = script_dir / 'output' / 'questions.json'
    
    # Generate and save
    questions = generate_questions(count_per_topic=args.count)
    save_to_json(questions, output_path)
    
    # İstatistikler
    topics = {}
    for q in questions:
        topic = q['topic']
        topics[topic] = topics.get(topic, 0) + 1
    
    print("\n📊 Topic Dağılımı:")
    for topic, count in sorted(topics.items()):
        print(f"   {topic}: {count} soru")


if __name__ == '__main__':
    main()
