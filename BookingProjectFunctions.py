import pandas as pd
import re

class BookingProjectFunctions:
    """Helper keywords for reading/writing the Excel file and normalising
    values.  Imported into Robot Framework as a library.  """

    def read_excel(self, path):
        """Return list of dicts, headers stripped of whitespace."""
        df = pd.read_excel(path, dtype=str)          # requires pandas
        df.columns = [c.strip() for c in df.columns]
        return df.to_dict(orient="records")

    def digits_only(self, text):
        """Return only the decimal digits from *text* ('' if None)."""
        if text is None:
            return ""
        return re.sub(r"\D", "", str(text))

    def write_excel(self, path, rows):
        """Overwrite the workbook with the modified rows list."""
        df = pd.DataFrame(rows)
        df.to_excel(path, index=False)
