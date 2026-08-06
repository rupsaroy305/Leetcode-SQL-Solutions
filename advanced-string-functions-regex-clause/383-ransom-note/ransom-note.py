class Solution:
    def canConstruct(self,ransomNote,magazine):

        mp={}

        for c in magazine:
            if c in mp:
                mp[c]+=1
            else:
                mp[c]=1

        for c in ransomNote:
            if c not in mp or mp[c]==0:
                return False
            mp[c]-=1

        return True