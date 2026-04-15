
import pandas as pd
import subprocess
import os


#1.convert fractions correctly 
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

#2.automate the ids for each file 
def automate_ids(files, id_column): 
    df[id_column] = range(1, len(df) + 1)
    return df 

#2.clean the files 
def clean_dataframe(df):

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


    return df


df_recipes = pd.read_csv('seeds/recipes.csv')
df_recipes = clean_dataframe(df_recipes)
df_recipes['recipe_id'] = range(1, len(df_recipes) + 1)

#recipe mapping 
recipe_lookup = dict(zip(df_recipes['recipe_url'], df_recipes['recipe_id']))

#save recipe cleaned file first 
df_recipes.to_csv('seeds/cleaned_recipes.csv', index=False)

files = {'recipe_trials.csv': 'trial_id'
        , 'recipes.csv': 'recipe_id'
        , 'ingredients.csv': 'ingredient_id'}

for file_name, id_column in files.items():

    df = pd.read_csv(f'seeds/{file_name}')
    df = clean_dataframe(df)

    #autoamte the ids 
    df = automate_ids(df, id_column)
    # if 'recipe_url' in df.columns:
    #     df['recipe_id'] = df['recipe_url'].map(recipe_lookup)

    df.to_csv(f'seeds/cleaned_{file_name}', index=False)

# 4. SAVE (Create a 'cleaned_' version of each)
df.to_csv(f'seeds/cleaned_{file_name}', index=False)
print(f"Cleaned and saved: cleaned_{file_name}")


#RUN DBT 
subprocess.run(["dbt", "seed", "--full-refresh"])
subprocess.run(["dbt", "run"])
print("SUCCESS: Your project is updated!")