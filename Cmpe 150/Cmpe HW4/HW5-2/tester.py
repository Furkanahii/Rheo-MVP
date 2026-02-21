import subprocess
import os
import glob
import sys

# --- AYARLAR ---
PYTHON_CMD = "python3"  # Mac/Linux için 'python3' olabilir
SCRIPT_NAME = "hw5.py"
INPUT_DIR = "inputs"
REF_OUTPUT_DIR = "outputs"
REF_ERROR_DIR = "errors"
MY_OUTPUT_DIR = "my_outputs"
OBJ_DIR = "objs"

# Renkli çıktılar için
class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    RESET = '\033[0m'
    YELLOW = '\033[93m'

def normalize_text(text):
    """Satır sonu karakterlerini ve boşlukları temizler."""
    if not text: return ""
    return text.strip().replace('\r\n', '\n')

def read_file(path):
    if not os.path.exists(path):
        return None
    with open(path, 'r', encoding='utf-8') as f:
        return normalize_text(f.read())

def run_test():
    # Klasörleri oluştur
    os.makedirs(MY_OUTPUT_DIR, exist_ok=True)
    os.makedirs(OBJ_DIR, exist_ok=True)

    # Tüm input dosyalarını bul ve numaraya göre sırala
    input_files = glob.glob(os.path.join(INPUT_DIR, "input-*.txt"))
    # Dosya adındaki numarayı çekip sıralama (input-2.txt, input-10.txt sırası bozulmasın diye)
    input_files.sort(key=lambda x: int(x.split('-')[-1].split('.')[0]))

    total_tests = 0
    passed_tests = 0
    failed_details = []

    print(f"{'TEST':<15} {'DURUM':<10} {'DETAY'}")
    print("-" * 60)

    for in_file in input_files:
        total_tests += 1
        base_name = os.path.basename(in_file) # input-0.txt
        test_id = base_name.split('-')[1].split('.')[0] # 0
        
        # Dosya yolları
        obj_file = os.path.join(OBJ_DIR, f"obj-{test_id}.obj")
        my_out_file = os.path.join(MY_OUTPUT_DIR, f"output-{test_id}.txt")
        
        # Referans dosyalar (Doğru cevaplar)
        ref_out_file = os.path.join(REF_OUTPUT_DIR, f"output-{test_id}.txt")
        ref_err_file = os.path.join(REF_ERROR_DIR, f"err-{test_id}.txt")

        error_message = ""
        is_compile_error = False
        is_runtime_error = False

        # --- 1. ADIM: COMPILE ---
        try:
            cmd = [PYTHON_CMD, SCRIPT_NAME, "-compile", in_file, obj_file]
            result = subprocess.run(cmd, capture_output=True, text=True)
            
            if result.returncode != 0:
                # Compile hatası verdi
                is_compile_error = True
                # stderr'den son satırı al (Exception mesajı)
                error_lines = result.stderr.strip().split('\n')
                error_message = error_lines[-1] if error_lines else ""
                
        except Exception as e:
            print(f"{Colors.RED}CRITICAL FAIL{Colors.RESET} {base_name}: {e}")
            continue

        # --- 2. ADIM: EXECUTE (Eğer derleme başarılıysa) ---
        if not is_compile_error:
            try:
                cmd = [PYTHON_CMD, SCRIPT_NAME, "-execute", obj_file, my_out_file]
                result = subprocess.run(cmd, capture_output=True, text=True)
                
                if result.returncode != 0:
                    # Runtime hatası verdi
                    is_runtime_error = True
                    error_lines = result.stderr.strip().split('\n')
                    error_message = error_lines[-1] if error_lines else ""
                    
            except Exception as e:
                print(f"{Colors.RED}CRITICAL FAIL{Colors.RESET} {base_name}: {e}")
                continue

        # --- 3. ADIM: KARŞILAŞTIRMA ---
        
        expected_output = read_file(ref_out_file)
        expected_error = read_file(ref_err_file)
        
        actual_output = read_file(my_out_file)
        
        # Karşılaştırma Mantığı
        test_passed = False
        fail_reason = ""

        # A) Beklenen bir HATA dosyası varsa
        if expected_error:
            # Hata mesajı eşleşiyor mu?
            # Bizim kod "Runtime error line_no=X" fırlatıyor, dosyadaki de öyle olmalı.
            # Bazen dosya içeriği "Exception: ..." ile başlıyor olabilir, o yüzden "in" kullanacağız.
            
            clean_expected_err = expected_error.split("Exception:")[-1].strip() if "Exception:" in expected_error else expected_error
            clean_actual_err = error_message.split("Exception:")[-1].strip() if "Exception:" in error_message else error_message

            if clean_expected_err in clean_actual_err:
                # Compile hatası ise output dosyasına bakmaya gerek yok
                if "Compile error" in expected_error:
                    test_passed = True
                else:
                    # Runtime hatası ise: O ana kadar basılan outputlar EŞİT olmalı
                    if normalize_text(actual_output) == normalize_text(expected_output):
                        test_passed = True
                    else:
                        fail_reason = "Runtime Error doğru ama Output yanlış/eksik."
            else:
                fail_reason = f"Yanlış Hata Mesajı. Beklenen: '{clean_expected_err}', Gelen: '{clean_actual_err}'"
        
        # B) Beklenen hata YOKSA (Başarılı çalışmalı)
        else:
            if is_compile_error or is_runtime_error:
                fail_reason = f"Hata beklenmiyordu ama hata alındı: {error_message}"
            else:
                if normalize_text(actual_output) == normalize_text(expected_output):
                    test_passed = True
                else:
                    fail_reason = "Output Eşleşmedi."

        # Raporla
        if test_passed:
            passed_tests += 1
            print(f"{base_name:<15} {Colors.GREEN}PASS{Colors.RESET}")
        else:
            print(f"{base_name:<15} {Colors.RED}FAIL{Colors.RESET}   {fail_reason}")
            failed_details.append(f"{base_name}: {fail_reason}")

    print("-" * 60)
    print(f"Toplam Test: {total_tests}")
    print(f"Başarılı:    {Colors.GREEN}{passed_tests}{Colors.RESET}")
    print(f"Başarısız:   {Colors.RED}{total_tests - passed_tests}{Colors.RESET}")
    
    if failed_details:
        print("\n--- HATA DETAYLARI ---")
        for det in failed_details[:10]: # İlk 10 hatayı göster
            print(det)
        if len(failed_details) > 10:
            print("... ve diğerleri.")

if __name__ == "__main__":
    run_test()
