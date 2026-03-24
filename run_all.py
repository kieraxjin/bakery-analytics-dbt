
import pandas as pd
import subprocess
import os


def convert_fractions(amount):
    amount = str(amount).strip()
    try: 
        if ' ' in amount:
            val = amount.split(' ')
            return float(val[0] + eval(val[1]))
        
        if '/' in amount: 
            return eval(amount)
        return float(amount)
    except:
        return amount



#1.READ RAW FILES IN 
files = ['recipe_trials.csv', 'ingredients.csv', 'recipes.csv']

for file_name in files:

    df = pd.read_csv(f'seeds/{file_name}')
    
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
        df['ingredient_name'] = df['ingredient_name'].str.title()
        
    if 'ingredient_amount' in df.columns:
        df['ingredient_amount'] = df['ingredient_amount'].apply(convert_fractions)

    # 4. SAVE (Create a 'cleaned_' version of each)
    df.to_csv(f'seeds/cleaned_{file_name}', index=False)
    print(f"Cleaned and saved: cleaned_{file_name}")




#RUN DBT 
subprocess.run(["dbt", "seed"])
subprocess.run(["dbt", "run"])
print("SUCCESS: Your project is updated!")