
import pandas as pd
import subprocess
import os


def convert_fractions(val):
    val = str(val).lower().strip()

    #handling na or empty cells 
    if val in ['na', '', 'none', 'nan']: 
        return 0.0

    try: 
        #1.handle spilt with x 
        if 'x' in val:
            val = val.split('x')
            return round(float(val[0]) * eval(val[1]),2)
        
        if ' ' in val:
            val = val.split(' ')
            return round(float(val[0]) + eval(val[1]),2)
        
        if '/' in val: 
            return eval(val)
        return round(float(val),2)
    except:
        return round(val,2)



#1.READ RAW FILES IN 
files = ['recipe_trials.csv', 'ingredients.csv', 'recipes.csv']

for file_name in files:

    df = pd.read_csv(f'seeds/{file_name}')

    # print(df.columns)
    
    #clean columns 
    df.columns = df.columns.str.strip().str.lower().str.replace(' ', '_')

    if 'recipe_name' in df.columns:
        df['recipe_name'] = df['recipe_name'].str.title().str.strip()
    
    if 'category' in df.columns:
        df['category'] = df['category'].str.title().str.strip()
    
    if 'recipe_url' in df.columns:
        df['recipe_url'] = df['recipe_url'].str.strip().str.lower()
        df['recipe_url'] = df['recipe_url'].replace('na', '')
    
    if 'ingredient_name' in df.columns:
        df['ingredient_name'] = df['ingredient_name'].str.title().str.strip()
        
    if 'amount' in df.columns:
        df['amount'] = df['amount'].apply(convert_fractions)

    # 4. SAVE (Create a 'cleaned_' version of each)
    df.to_csv(f'seeds/cleaned_{file_name}', index=False)
    print(f"Cleaned and saved: cleaned_{file_name}")




#RUN DBT 
subprocess.run(["dbt", "seed", "--full-refresh"])
subprocess.run(["dbt", "run"])
print("SUCCESS: Your project is updated!")